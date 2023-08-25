CREATE TABLE MyDimDate(
    dateid bigint not null,
    fulldate date,
    year integer,
    quarter integer,
    quartername varchar(2),
    month integer,
    monthname varchar(22),
    days integer,
    weekdays integer,
    weekname varchar(22)
);
ALTER TABLE MyDimDate 
ADD PRIMARY KEY (dateid);


CREATE TABLE MyDimWaste (
    wasteid bigint,
    wastetype varchar(32)
);
ALTER TABLE MyDimWaste 
ADD PRIMARY KEY (wasteid);


CREATE TABLE MyDimZone(
    zoneid bigint,
    region varchar(20),
    city varchar(32)
); 
ALTER TABLE MyDimZone
ADD PRIMARY KEY (zoneid);


CREATE TABLE MyFactTrips(
    tripsid bigint
    quantity float,
    dateid bigint,
    wasteid bigint,
    zoneid bigint
)
ALTER TABLE MyFactTrips
ADD FOREIGN KEY(dateid) REFERENCES MyDimDate(dateid);
ALTER TABLE MyFactTrips
ADD FOREIGN KEY(wasteid) REFERENCES MyDimWaste(wasteid);
ALTER TABLE MyFactTrips
ADD FOREIGN KEY(zoneid) REFERENCES MyDimZone(zoneid);

CREATE TABLE max_waste_stats (city,zoneid,wastetype,maximumwaste) AS
  (select city,myfacttrips.zoneid,wastetype,MAX(quantity) as maxi
from myfacttrips
left join mydimzone   
on myfacttrips.zoneid = mydimzone.zoneid
left join mydimwaste
on myfacttrips.wasteid=mydimwaste.wasteid
group by city,myfacttrips.zoneid,wastetype)
     DATA INITIALLY DEFERRED
     REFRESH DEFERRED
     MAINTAINED BY SYSTEM;
REFRESH TABLE max_waste_stats;
