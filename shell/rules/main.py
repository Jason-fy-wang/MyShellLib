
import os, sys, time, json, uuid, logging, argparse, datetime, configparser, numpy as np, pandas as pd
from logging import handlers
from db import HandlePostgres
from efficient_apriori import apriori
key_field = 'eventTime'
features_sep = '|'
curPath = os.path.abspath(os.path.dirname(__file__))
project_root_path = os.path.abspath(curPath + os.path.dirname('../'))
config_path = '/opt/ericsson/nfvo/fcaps/ml/config/config.properties'
cf = configparser.ConfigParser()
cf.read(config_path, encoding='utf-8')
feature_list = cf.get('DataConfig', 'feature_list').split(';')
min_support = float(cf.get('DataConfig', 'min_support'))
min_confidence = float(cf.get('DataConfig', 'min_confidence'))
recently = int(cf.get('DataConfig', 'recently'))
time_window = int(cf.get('DataConfig', 'time_window'))
window_step = int(cf.get('DataConfig', 'window_step'))
data_file_path = cf.get('FileConfig', 'input_path')
nfvo_state_path = cf.get('FileConfig', 'nfvo_state_path')
log_file_path = cf.get('LogConfig', 'log_file_path')
log_backup_count = int(cf.get('LogConfig', 'log_backup_count'))
logger = logging.getLogger('main')
logger.setLevel(level=(logging.INFO))
formatter = logging.Formatter('%(asctime)s - %(levelname)s: %(message)s')
stream_handler = logging.StreamHandler()
stream_handler.setLevel(level=(logging.INFO))
stream_handler.setFormatter(formatter)
file_handler = handlers.TimedRotatingFileHandler(filename=log_file_path, when='D', backupCount=log_backup_count, encoding='utf-8')
file_handler.setLevel(level=(logging.INFO))
file_handler.setFormatter(formatter)
logger.addHandler(stream_handler)
logger.addHandler(file_handler)

def batch_read(data_features, time_window_shard):
    logger.info('to read data source file...')
    chunks = {}
    min_key = sys.maxsize
    max_key = 0
    try:
        file_list = os.listdir(data_file_path)
        for f in file_list:
            if f.startswith('standard_alarm_') and date_from <= int(f[-12:-4]) <= date_to:
                df = pd.read_csv((data_file_path + f), low_memory=False)
                if df.empty:
                    pass
                else:
                    data = pd.json_normalize(df['alarm_content'].map(json.loads).tolist())
                    data[key_field] = data[key_field].apply(lambda x: time.mktime(time.strptime(x, '%Y-%m-%d %H:%M:%S'))) / time_window_shard
                    data[key_field] = data[key_field].astype('int64')
                    min_key = min(min_key, data.iloc[0][key_field])
                    max_key = max(max_key, data.iloc[(-1)][key_field])
                    key_field_frame = data.groupby(key_field).count().reset_index()
                    key_field_series = key_field_frame[key_field]
                    features = data_features.split(',')
                    data[data_features] = data[features[0]]
                    for i in range(1, len(features)):
                        data[data_features] = data[data_features] + features_sep + data[features[i]]

                    max_length = 0
                    array = []
                    for key, group in data.groupby(key_field):
                        temp_array = list(set(np.array(group[data_features])))
                        array.append(temp_array)
                        max_length = max(max_length, len(temp_array))

                    key_field_data = pd.DataFrame(array).fillna('')
                    key_field_data[max_length] = key_field_series
                    for row in key_field_data.itertuples():
                        key = int(row[(max_length + 1)])
                        for i in range(1, max_length + 1):
                            if row[i]:
                                value = row[i]
                                if not isinstance(row[i], str):
                                    value = str(row[i])
                                if key in chunks:
                                    chunks[key].add(value)
                                else:
                                    chunks[key] = {
                                     value}

        return (
         chunks, int(min_key), int(max_key))
    except Exception as e:
        raise Exception('error reading the file: ' + str(e))


def data_processing(chunks, min_key, max_key, window_shard_num, window_shard_step):
    logger.info('to processing data...')
    key = min_key
    data = []
    try:
        while key <= max_key:
            sliding_window = []
            for i in range(0, window_shard_num):
                if key + i in chunks.keys():
                    sliding_window.extend(chunks[(key + i)])

            if len(sliding_window) > 0:
                data.append(tuple(set(sliding_window)))
            key += window_shard_step

        return data
    except Exception as e:
        raise Exception('error processing data: ' + str(e))


def gcd(p, q):
    while p != q:
        if p > q:
            p = p - q
        else:
            q = q - p

    return q


def rule_mining():
    association_rules_dict = {}
    time_window_shard = gcd(time_window, window_step)
    window_shard_num = time_window // time_window_shard
    window_shard_step = window_step // time_window_shard
    for i, feature in enumerate(feature_list):
        try:
            if 'specialty' not in feature:
                feature += ',specialty'
            feature_sort = ','.join(sorted(feature.split(',')))
            logger.info('the data features[%d]: %s' % (i + 1, feature_sort))
            data_source, min_field, max_field = batch_read(feature_sort, time_window_shard)
            data_set = data_processing(data_source, min_field, max_field, window_shard_num, window_shard_step)
            item_set, rules = apriori(data_set, min_support=min_support, min_confidence=min_confidence, max_length=2)
            res = []
            for r in rules:
                ll, rl = list(r.lhs), list(r.rhs)
                res.append([ll[0], rl[0], r.support, r.confidence])

            resDf = pd.DataFrame(res, columns=['lhs', 'rhs', 'support', 'confidence'])
            if not resDf.empty:
                association_rules_dict[feature_sort] = resDf
        except Exception as e:
            logger.error('the association rule mining failed:' + str(e))

    return association_rules_dict


def rule_drop_duplicates(association_rules_dict):
    logger.info('to drop duplicate rules...')
    result = {}
    for key in association_rules_dict.keys():
        df = association_rules_dict[key]
        df['ahs'] = (df['lhs'] + features_sep + df['rhs']).str.split(features_sep)
        df['ahs'].apply(lambda x: list.sort(x))
        df['ahs'] = df['ahs'].apply(lambda x: ','.join(x))
        df = df.sort_values(by='confidence', ascending=False, axis=0)
        df = df.drop_duplicates(['ahs'])
        df = df.drop(columns=['ahs'])
        df = df.reset_index(drop=True)
        result[key] = df

    return result


def rule_format(association_rules_dict, startDate, endDate):
    logger.info('to format rules...')
    sql_search = 'select mined_rule_id, feature_rule_left, left_specialty, \n        feature_rule_right, right_specialty, feature_columns\n        from correlation_rule_mined'
    handlePostgres = HandlePostgres(cf)
    try:
        try:
            handlePostgres.conn_postgres()
            association_rules_data = handlePostgres.search_as_df(sql_search)
        except Exception as e:
            raise Exception('database error: ' + str(e))

    finally:
        handlePostgres.close_postgres()

    insert_values = []
    update_values = []
    for key in association_rules_dict.keys():
        key_list = key.split(',')
        feature_columns = key.split(',')
        feature_columns.remove('specialty')
        feature_columns = ','.join(feature_columns)
        for index, row in association_rules_dict[key].iterrows():
            try:
                values = []
                lhs_dict = dict(zip(key_list, row['lhs'].split(features_sep)))
                rhs_dict = dict(zip(key_list, row['rhs'].split(features_sep)))
                left_specialty = lhs_dict.pop('specialty')
                right_specialty = rhs_dict.pop('specialty')
                values.append(json.dumps(lhs_dict, ensure_ascii=False))
                values.append(left_specialty)
                values.append(json.dumps(rhs_dict, ensure_ascii=False))
                values.append(right_specialty)
                values.append(feature_columns)
                values.append(time_window)
                values.append(window_step)
                values.append(round(float(row['support']), 4))
                values.append(round(float(row['confidence']), 4))
                values.append(str(datetime.datetime.strptime(str(startDate), '%Y%m%d')))
                values.append(str(datetime.datetime.strptime(str(endDate), '%Y%m%d') + datetime.timedelta(hours=23, minutes=59, seconds=59)))
                values.append(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
                rule = association_rules_data.loc[((association_rules_data['feature_columns'] == feature_columns) & ((association_rules_data['feature_rule_left'] == lhs_dict) & (association_rules_data['feature_rule_right'] == rhs_dict) | (association_rules_data['feature_rule_right'] == lhs_dict) & (association_rules_data['feature_rule_left'] == rhs_dict)) & (association_rules_data['left_specialty'] == left_specialty) & (association_rules_data['right_specialty'] == right_specialty))]
                if rule.empty:
                    values.insert(0, ''.join(str(uuid.uuid4()).split('-')))
                    insert_values.append(tuple(values))
                else:
                    values.append(rule['mined_rule_id'].tolist()[0])
                    update_values.append(tuple(values))
            except Exception as e:
                logger.error('rule=%s format error: %s' % (row.to_json(), str(e)))

    return (
     insert_values, update_values)


def rule_save(insert_values, update_values):
    logger.info('to save rules into database...')
    sql_insert = 'insert into correlation_rule_mined(mined_rule_id, feature_rule_left, left_specialty, \n    feature_rule_right, right_specialty, feature_columns, time_window, window_step, support, confidence, start_time, \n    end_time, update_time) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'
    sql_update = 'update correlation_rule_mined set feature_rule_left=%s, left_specialty=%s, \n    feature_rule_right=%s, right_specialty=%s, feature_columns=%s, time_window=%s, window_step=%s, support=%s, \n    confidence=%s, start_time=%s, end_time=%s, update_time=%s where mined_rule_id = %s'
    handlePostgres = HandlePostgres(cf)
    try:
        try:
            handlePostgres.conn_postgres()
            handlePostgres.batch_execute(sql_insert, insert_values)
            handlePostgres.batch_execute(sql_update, update_values)
            logger.info('rules saved successfully: insert %d rules and update %d rules' % (len(insert_values), len(update_values)))
        except Exception as e:
            raise Exception('database error: ' + str(e))

    finally:
        handlePostgres.close_postgres()


if __name__ == '__main__':
    nfvo_state = 'master'
    try:
        with open(nfvo_state_path, 'r', encoding='utf-8') as (f):
            lines = f.read().splitlines()
            nfvo_state = lines[0]
    except IOError:
        logger.warning('the nfvo state file does not exist, and nfvo_state is set to the default value master.')

    if nfvo_state.lower() != 'master':
        logger.info('the nfvo_state is not master, so this program will not run.')
        sys.exit(0)
    parser = argparse.ArgumentParser(usage='\n  指定起始与截止时间: python main.py -w 300 -f 20200601 -t 20200630 \n  指定处理最近的数据: python main.py -w 300 -r 30')
    parser.add_argument('-w', '--windows', type=int, dest='time_window', metavar='', help=('时间窗口 默认%d秒' % time_window))
    parser.add_argument('-r', '--recently', default=recently, type=int, dest='recently', metavar='', help=('处理最近的数据 默认%d天' % recently))
    parser.add_argument('-f', '--from', type=int, dest='date_from', metavar='', help='起始时间 格式为: YYYYmmdd')
    parser.add_argument('-t', '--to', type=int, dest='date_to', metavar='', help='截止时间 格式为: YYYYmmdd')
    args = parser.parse_args()
    today = datetime.date.today()
    if args.time_window:
        time_window = args.time_window
        window_step = time_window // 3 * 2
    recently = args.recently
    date_from = args.date_from
    date_to = args.date_to
    if not date_from or not date_to:
        date_from = int((today - datetime.timedelta(days=recently)).strftime('%Y%m%d'))
        date_to = int(today.strftime('%Y%m%d'))
    if recently > 365 or date_from < 19700101 or date_to > int(datetime.datetime.now().strftime('%Y%m%d')):
        logger.error("the arguments is invalid, please use '-h' for help")
        sys.exit(0)
    logger.info('the program is running...')
    try:
        logger.info('data process config: {date_from=%s, date_to=%s, time_window=%s, window_step=%s}' % (date_from, date_to, time_window, window_step))
        rules_dict = rule_mining()
        if rules_dict:
            rules_dict = rule_drop_duplicates(rules_dict)
            rules_insert, rules_update = rule_format(rules_dict, date_from, date_to)
            rule_save(rules_insert, rules_update)
        else:
            logger.info('there is no association rules were mined')
    except Exception as exception:
        logger.error('stop running:' + str(exception))
        sys.exit(0)

    logger.info('finished running')
# okay decompiling main.pyc
