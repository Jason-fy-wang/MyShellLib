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