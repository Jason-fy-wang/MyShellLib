drop table if exists alarm_processing_flow;
create table alarm_processing_flow(
    statistical_type varchar(36),
    time_point  varchar(20),
    time_point_stamp timestamp,
    amount  integer,
    update_time timestamp,
    primary key(statistical_type,time_point)
);
create index index_alarm_processing_flow_1 on alarm_processing_flow(time_point_stamp);
create index index_alarm_processing_flow_2 on alarm_processing_flow(update_time);

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
