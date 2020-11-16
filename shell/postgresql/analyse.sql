drop table if exists alarm_processing_flow;
create table alarm_processing_flow(
    statistical_type varchar(36),
    time_point  varchar(20),
    time_point_stamp timestamp,
    amount  integer,
    update_time timestamp,
    primary key(statistical_type,time_point)
);
create index ttt_flow_1 on alarm_processing_flow(time_point_stamp);
create index ttt_flow_2 on alarm_processing_flow(update_time);

'202009201300','2020-09-20 13:00:00'
'202009211300','2020-09-21 13:00:00'
'202009221300','2020-09-22 13:00:00'

insert into alarm_processing_flow(statistical_type,time_point,time_point_stamp,amount,update_time)
values('collectedAlarm','202009201300','2020-09-20 13:00:00',1000,now),
('duplicatedAlarm','202009201300','2020-09-20 13:00:00',100,now),
('filteredAlarm','202009201300','2020-09-20 13:00:00',30,now),
('engineeringAlarm','202009201300','2020-09-20 13:00:00',500,now),
('standardAlarm','202009201300','2020-09-20 13:00:00',870,now),
('correlationAlarm','202009201300','2020-09-20 13:00:00',300,now),
('reportOSSAlarm','202009201300','2020-09-20 13:00:00',870,now);

insert into alarm_processing_flow(statistical_type,time_point,time_point_stamp,amount,update_time)
values('collectedAlarm','202009211300','2020-09-21 13:00:00',1000,now),
('duplicatedAlarm','202009211300','2020-09-21 13:00:00',100,now),
('filteredAlarm','202009211300','2020-09-21 13:00:00',30,now),
('engineeringAlarm','202009211300','2020-09-21 13:00:00',500,now),
('standardAlarm','202009211300','2020-09-21 13:00:00',870,now),
('correlationAlarm','202009211300','2020-09-21 13:00:00',300,now),
('reportOSSAlarm','202009211300','2020-09-21 13:00:00',870,now);

insert into alarm_processing_flow(statistical_type,time_point,time_point_stamp,amount,update_time)
values('collectedAlarm','202009221300','2020-09-22 13:00:00',1000,now),
('duplicatedAlarm','202009221300','2020-09-22 13:00:00',100,now),
('filteredAlarm','202009221300','2020-09-22 13:00:00',30,now),
('engineeringAlarm','202009221300','2020-09-22 13:00:00',500,now),
('standardAlarm','202009221300','2020-09-22 13:00:00',870,now),
('correlationAlarm','202009221300','2020-09-22 13:00:00',300,now),
('reportOSSAlarm','202009221300','2020-09-22 13:00:00',870,now);

select statistical_type,sum(amount) amount from alarm_processing_flow where time_point_stamp>='2020-09-21 13:00:00' and time_point_stamp<='2020-09-22 13:00:00' group by statistical_type;

select statistical_type, amount, round(cast(amount as numeric)/ cast((select sum(amount) amount from alarm_processing_flow where time_point_stamp>='2020-09-21 13:00:00' and time_point_stamp<='2020-09-22 13:00:00' and  statistical_type='collectedAlarm')as numeric),2)rate from (
select statistical_type,sum(amount) amount from alarm_processing_flow where time_point_stamp>='2020-09-21 13:00:00' and time_point_stamp<='2020-09-22 13:00:00' group by statistical_type) b ;


alter table if exists alarm_processing_flow add column attribute varchar(255) default '';
alter table if exists alarm_processing_flow add column sub_attribute varchar(255) default ;
alter table if exists alarm_processing_flow add column attribute_cn_name varchar(255);

alter table if exists alarm_processing_flow drop constraint "alarm_processing_flow_pkey";
alter table if exists alarm_processing_flow add primary key(statistical_type,time_point,attribute,sub_attribute);

insert into alarm_processing_flow(statistical_type,time_point,time_point_stamp,attribute,sub_attribute,attribute_cn_name,amount,update_time) 
values ('collectedAlarm','202011041058','2020-11-04 10:58:30','vim01','','vim01采集源',10,now()),
('collectedAlarm','202011041059','2020-11-04 10:59:30','pim01','','pim01采集源',5,now()),
('duplicatedAlarm','202011041104','2020-11-04 11:04:30','','','',6,now()),
('filteredAlarm','202011041104','2020-11-04 11:04:30','','','',6,now()),
('engineeringAlarm','202011041104','2020-11-04 11:04:30','rule_engineering_suppression_2020110411130231','','工程告警1',6,now()),
('engineeringAlarm','202011041104','2020-11-04 11:04:30','rule_engineering_suppression_2020110411130242','','工程告警2',7,now()),
('standardAlarm','202011041104','2020-11-04 11:04:30','host','1101ERHX2SCTBEC7C7539B8CE7','NFV-D-HNGZ-01A-2302-AH17-S-SRV-16',7,now()),
('standardAlarm','202011041104','2020-11-04 11:04:30','server','1101ERHX2SCTBEC7C7539B8CE9','NFV-D-HNGZ-01A-2302-AH17-S-SRV-15',7,now()),
('notStandardAlarm','202011041104','2020-11-04 11:04:30','host','1101ERHX2SCTBEC7C7539B8CE10','NFV-D-HNGZ-01A-2302-AH17-S-SRV-14',5,now()),
('notStandardAlarm','202011041104','2020-11-04 11:04:30','server','1101ERHX2SCTBEC7C7539B8CE12','NFV-D-HNGZ-01A-2302-AH17-S-SRV-13',5,now()),
('correlationAlarm','202011041104','2020-11-04 11:04:30','rule_master_slave__2020110411130231','','主从告警规则1',6,now()),
('correlationAlarm','202011041104','2020-11-04 11:04:30','rule_engineering_suppression_2020110411130231','','工程告警1',6,now()),
('reportOSSAlarm','202011041104','2020-11-04 11:04:30','','','',5,now()),
('reportOSSCorrelationAlarm','202011041104','2020-11-04 11:04:30','','','',6,now()),
('reportOSSAlarmDetail','202011041104','2020-11-04 11:04:30','oss01','','oss01',2,now()),
('reportOSSAlarmDetail','202011041104','2020-11-04 11:04:30','oss02','','oss02',3,now()),
('reportOSSCorrelationAlarmDetail','202011041104','2020-11-04 11:04:30','oss01','','oss01',3,now()),
('reportOSSCorrelationAlarmDetail','202011041104','2020-11-04 11:04:30','oss02','','oss02',3,now());

select statistical_type,sum(amount) count from alarm_processing_flow where time_point_stamp >= '2020-11-04 00:00:00' and time_point_stamp <= '2020-11-05 00:00:00' group by statistical_type;

select b.statistical_type,b.count,b.attribute,b.sub_attribute,a.attribute_cn_name,a.time_point_stamp from alarm_processing_flow a, (
select statistical_type,attribute,sub_attribute,sum(amount) count from alarm_processing_flow  group by statistical_type,attribute,sub_attribute) b where a.statistical_type = b.statistical_type and a.attribute = b.attribute and a.sub_attribute = b.sub_attribute and time_point_stamp >= '2020-11-04 00:00:00' and time_point_stamp <= '2020-11-05 00:00:00';

select b.statistical_type,b.count,b.attribute,b.sub_attribute,a.attribute_cn_name from alarm_processing_flow a, (
select statistical_type,attribute,sub_attribute,sum(amount) count from alarm_processing_flow where time_point_stamp >= '2020-11-04 00:00:00' and time_point_stamp <= '2020-11-05 00:00:00' group by statistical_type,attribute,sub_attribute) b where a.statistical_type = b.statistical_type and a.attribute = b.attribute and a.sub_attribute = b.sub_attribute;


select attribute,attribute_cn_name from alarm_processing_flow where attribute != '';

insert into engineering_suppression_rule(rule_id,rule_name,rule_desc,slave_mvel,alarm_object_list,master_alarm_title,start_time,end_time,if_report_oss,update_time,match_alarm_title) values('123','engewin1','desc1','slavemven','{"title":"title"}','123','2020-10-26 00:00:00','2020-10-26 00:00:00', true,'2020-10-26 00:00:00', ,);




---------------------excel 映射字段添加
insert into field_enum_value(field,cn_name,value) values
('AlarmFieldName','告警唯一标识','alarmId'),
('AlarmFieldName','告警标题','alarmTitle'),
('AlarmFieldName','告警状态','clearFlag'),
('AlarmFieldName','是否根告警','ifRoot'),
('AlarmFieldName','是否主告警','ifMaster'),
('AlarmFieldName','是否从告警','ifSlave'),
('AlarmFieldName','是否本大区产生','localProducer'),
('AlarmFieldName','是否归属于本大区','localOwner'), 
('AlarmFieldName','告警对象名称','objectName'),
('AlarmFieldName','告警对象类型','objectType'),
('AlarmFieldName','告警类型','alarmType'),
('AlarmFieldName','原始告警级别','origSeverity'),
('AlarmFieldName','网管告警级别','netManagerAlarmSeverity'), 
('AlarmFieldName','告警数据源','dataSource'),
('AlarmFieldName','设备厂家','vendorName'),
('AlarmFieldName','告警发生时间','eventTime'),
('AlarmFieldName','告警最晚上报时间','latestArriveTime'),
('AlarmFieldName','原始的告警ID','initialAlarmId'),
('AlarmFieldName','告警信息序号','alarmSeq'),
('AlarmFieldName','告警问题原因Id','specificProblemID'),
('AlarmFieldName','告警问题原因','specificProblem'),
('AlarmFieldName','告警对象UID','objectUID'),
('AlarmFieldName','告警定位对象UID','subObjectUID'),
('AlarmFieldName','告警定位对象名称','subObjectName'),
('AlarmFieldName','告警定位对象资源类型','subObjectType'),
('AlarmFieldName','告警定位信息','locationInfo'),
('AlarmFieldName','告警辅助信息','addInfo'),
('AlarmFieldName','告警设备的虚实性','pVFlag'),
('AlarmFieldName','标准化结果','standardFlag'),
('AlarmFieldName','是否已确认','confirmFlag'),
('AlarmFieldName','告警专业类型','specialty'),
('AlarmFieldName','告警涉及的vmId列表','vmIdList'),
('AlarmFieldName','告警涉及的HostId列表','hostIdList'),
('AlarmFieldName','网管告警ID','netManagerAlarmId'),
('AlarmFieldName','业务类型','businessType'),
('AlarmFieldName','告警清除人','clearOperateUser'),
('AlarmFieldName','告警清除时间','clearTime'),
('AlarmFieldName','归属域 （CT/IT）','domainType'),
('AlarmFieldName','告警源ID','sourceID'),
('AlarmFieldName','告警是否过滤','isFilter'),
('AlarmFieldName','是否工程告警','pFlag'),
('AlarmFieldName','S-NSSAI列表','snssaiList'),
('AlarmFieldName','NSSI列表','nssiList'),
('AlarmFieldName','NSSI名称列表','nssiNameList'),

('DataSourceType','虚拟资源','VIM'),
('DataSourceType','物理资源','PIM'),
('DataSourceType','VNF业务','EMS'),
('DataSourceType','sm','SM'),
('DataSourceType','pm','PM');



-------------------------------------------------------------------notify
drop table if exists alarm_sms_notification_configuration;
create table alarm_sms_notification_configuration (
    auto_id serial,
    object_type varchar(255),
    orig_severity integer,
    mvel_match varchar(255) not null,
    notification_template varchar(1024) not null,
    clear_notification_template varchar(1024) not null,
    receiver    jsonb not null,
    update_time timestamp not null,
    primary key (auto_id)
);

drop table if exists alarm_notification_result;
create table alarm_notification_result (
    alarm_id     character varying(36)        not null,
    alarm_status smallint                     not null,
    alarm_seq   integer                       not null,
    msg_content  character varying(1024)      not null,
    receiver     jsonb                        not null,
    result       character varying(36)        not null,
    error_desc   character varying(1024),
    If_send_clear_sms boolean                 default false,
    update_time  timestamp without time zone  not null,
    primary key(alarm_id, alarm_status, alarm_seq)
);