-- Tags: no-fasttest, long, no-debug, no-tsan, no-asan, no-msan, no-ubsan

set allow_experimental_json_type = 1;
set allow_experimental_variant_type = 1;
set use_variant_as_common_type = 1;
set session_timezone = 'UTC';

drop table if exists test;
create table test (id UInt64, json JSON(max_dynamic_paths=2, a.b.c UInt32)) engine=Memory;

truncate table test;
insert into test select number, '{}' from numbers(100000);
insert into test select number, toJSONString(map('a.b.c', number)) from numbers(100000, 100000);
insert into test select number, toJSONString(map('a.b.d', number::UInt32, 'a.b.e', 'str_' || toString(number))) from numbers(200000, 100000);
insert into test select number, toJSONString(map('b.b.d', number::UInt32, 'b.b.e', 'str_' || toString(number))) from numbers(300000, 100000);
insert into test select number, toJSONString(map('a.b.c', number, 'a.b.d', number::UInt32, 'a.b.e', 'str_' || toString(number))) from numbers(400000, 100000);
insert into test select number, toJSONString(map('a.b.c', number, 'a.b.d', number::UInt32, 'a.b.e', 'str_' || toString(number), 'b.b._' || toString(number % 5), number::UInt32)) from numbers(500000, 100000);
insert into test select number, toJSONString(map('a.b.c', number, 'a.b.d', range(number % + 1)::Array(UInt32), 'a.b.e', 'str_' || toString(number), 'd.a', number::UInt32, 'd.c', toDate(number))) from numbers(600000, 100000);
insert into test select number, toJSONString(map('a.b.c', number, 'a.b.d', toDateTime(number), 'a.b.e', 'str_' || toString(number), 'd.a', range(number % 5 + 1)::Array(UInt32), 'd.b', number::UInt32)) from numbers(700000, 100000);

select distinct arrayJoin(JSONAllPathsWithTypes(json)) as paths_with_types from test order by paths_with_types;

select json.non.existing.path, json.a.b.c, json.a.b.d, json.a.b.d.:Int64, json.a.b.d.:UUID, json.a.b.e, json.a.b.e.:String, json.a.b.e.:UUID, json.b.b.`_0`, json.b.b.`_0`.:Int64, json.b.b.`_0`.:UUID, json.b.b.`_1`, json.b.b.`_1`.:Int64, json.b.b.`_1`.:UUID, json.b.b.`_2`, json.b.b.`_2`.:Int64, json.b.b.`_2`.:UUID, json.b.b.`_3`, json.b.b.`_3`.:Int64, json.b.b.`_3`.:UUID, json.b.b.`_4`, json.b.b.`_4`.:Int64,  json.b.b.`_4`.:UUID, json.b.b.d, json.b.b.d.:Int64, json.b.b.d.:UUID, json.b.b.e, json.b.b.e.:String, json.b.b.e.:UUID, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:UUID, json.d.b, json.d.b.:Int64, json.d.b.:UUID, json.d.c, json.d.c.:Date, json.d.c.:UUID, json.^n, json.^a, json.^a.b, json.^b, json.^d from test format Null;
select json.non.existing.path, json.a.b.c, json.a.b.d, json.a.b.d.:Int64, json.a.b.d.:UUID, json.a.b.e, json.a.b.e.:String, json.a.b.e.:UUID, json.b.b.`_0`, json.b.b.`_0`.:Int64, json.b.b.`_0`.:UUID, json.b.b.`_1`, json.b.b.`_1`.:Int64, json.b.b.`_1`.:UUID, json.b.b.`_2`, json.b.b.`_2`.:Int64, json.b.b.`_2`.:UUID, json.b.b.`_3`, json.b.b.`_3`.:Int64, json.b.b.`_3`.:UUID, json.b.b.`_4`, json.b.b.`_4`.:Int64,  json.b.b.`_4`.:UUID, json.b.b.d, json.b.b.d.:Int64, json.b.b.d.:UUID, json.b.b.e, json.b.b.e.:String, json.b.b.e.:UUID, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:UUID, json.d.b, json.d.b.:Int64, json.d.b.:UUID, json.d.c, json.d.c.:Date, json.d.c.:UUID, json.^n, json.^a, json.^a.b, json.^b, json.^d from test order by id format Null;
select json, json.non.existing.path, json.a.b.c, json.a.b.d, json.a.b.d.:Int64, json.a.b.d.:UUID, json.a.b.e, json.a.b.e.:String, json.a.b.e.:UUID, json.b.b.`_0`, json.b.b.`_0`.:Int64, json.b.b.`_0`.:UUID, json.b.b.`_1`, json.b.b.`_1`.:Int64, json.b.b.`_1`.:UUID, json.b.b.`_2`, json.b.b.`_2`.:Int64, json.b.b.`_2`.:UUID, json.b.b.`_3`, json.b.b.`_3`.:Int64, json.b.b.`_3`.:UUID, json.b.b.`_4`, json.b.b.`_4`.:Int64,  json.b.b.`_4`.:UUID, json.b.b.d, json.b.b.d.:Int64, json.b.b.d.:UUID, json.b.b.e, json.b.b.e.:String, json.b.b.e.:UUID, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:UUID, json.d.b, json.d.b.:Int64, json.d.b.:UUID, json.d.c, json.d.c.:Date, json.d.c.:UUID, json.^n, json.^a, json.^a.b, json.^b, json.^d from test format Null;
select json, json.non.existing.path, json.a.b.c, json.a.b.d, json.a.b.d.:Int64, json.a.b.d.:UUID, json.a.b.e, json.a.b.e.:String, json.a.b.e.:UUID, json.b.b.`_0`, json.b.b.`_0`.:Int64, json.b.b.`_0`.:UUID, json.b.b.`_1`, json.b.b.`_1`.:Int64, json.b.b.`_1`.:UUID, json.b.b.`_2`, json.b.b.`_2`.:Int64, json.b.b.`_2`.:UUID, json.b.b.`_3`, json.b.b.`_3`.:Int64, json.b.b.`_3`.:UUID, json.b.b.`_4`, json.b.b.`_4`.:Int64,  json.b.b.`_4`.:UUID, json.b.b.d, json.b.b.d.:Int64, json.b.b.d.:UUID, json.b.b.e, json.b.b.e.:String, json.b.b.e.:UUID, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:UUID, json.d.b, json.d.b.:Int64, json.d.b.:UUID, json.d.c, json.d.c.:Date, json.d.c.:UUID, json.^n, json.^a, json.^a.b, json.^b, json.^d from test order by id format Null;

select count() from test where json.non.existing.path is Null;
select count() from test where json.non.existing.path.:String is Null;
select json.non.existing.path from test order by id format Null;
select json.non.existing.path.:Int64 from test order by id format Null;
select json.non.existing.path, json.non.existing.path.:Int64 from test order by id format Null;
select json, json.non.existing.path from test order by id format Null;
select json, json.non.existing.path.:Int64 from test order by id format Null;
select json, json.non.existing.path, json.non.existing.path.:Int64 from test format Null;
select json, json.non.existing.path, json.non.existing.path.:Int64 from test order by id format Null;

select count() from test where json.a.b.c == 0;
select json.a.b.c from test format Null;
select json.a.b.c from test order by id format Null;
select json, json.a.b.c from test format Null;
select json, json.a.b.c from test order by id format Null;

select count() from test where json.b.b.e is Null;
select count() from test where json.b.b.e.:String is Null;
select json.b.b.e from test format Null;
select json.b.b.e from test order by id format Null;
select json.b.b.e.:String, json.b.b.e.:Date from test format Null;
select json.b.b.e.:String, json.b.b.e.:Date from test order by id format Null;
select json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date from test format Null;
select json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date from test order by id format Null;
select json, json.b.b.e from test format Null;
select json, json.b.b.e from test order by id format Null;
select json, json.b.b.e.:String, json.b.b.e.:Date from test format Null;
select json, json.b.b.e.:String, json.b.b.e.:Date from test order by id format Null;
select json, json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date from test format Null;
select json, json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date from test order by id format Null;

select count() from test where json.b.b.e is Null and json.a.b.d is Null ;
select count() from test where json.b.b.e.:String is Null and json.a.b.d.:Int64 is Null;
select json.b.b.e, json.a.b.d from test order by id format Null;
select json.b.b.e.:String, json.b.b.e.:Date, json.a.b.d.:Int64, json.a.b.d.:Date from test order by id format Null;
select json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date, json.a.b.d, json.a.b.d.:Int64, json.a.b.d.:Date from test order by id format Null;
select json, json.b.b.e, json.a.b.d from test order by id format Null;
select json, json.b.b.e.:String, json.b.b.e.:Date, json.a.b.d.:Int64, json.a.b.d.:Date from test order by id format Null;
select json, json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date, json.a.b.d, json.a.b.d.:Int64, json.a.b.d.:Date from test format Null;
select json, json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date, json.a.b.d, json.a.b.d.:Int64, json.a.b.d.:Date from test order by id format Null;

select count() from test where json.b.b.e is Null and json.d.a is Null;
select count() from test where json.b.b.e.:String is Null and empty(json.d.a.:`Array(Nullable(Int64))`);
select json.b.b.e, json.d.a from test order by id format Null;
select json.b.b.e.:String, json.b.b.e.:Date, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date from test order by id format Null;
select json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date from test order by id format Null;
select json, json.b.b.e, json.d.a from test order by id format Null;
select json, json.b.b.e.:String, json.b.b.e.:Date, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date from test order by id format Null;
select json, json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date from test format Null;
select json, json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date from test order by id format Null;

select count() from test where json.b.b.e is Null and json.d.a is Null and json.d.b is Null;
select count() from test where json.b.b.e.:String is Null and empty(json.d.a.:`Array(Nullable(Int64))`) and json.d.b.:Int64 is Null;
select json.b.b.e, json.d.a, json.d.b from test order by id format Null;
select json.b.b.e.:String, json.b.b.e.:Date, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.d.b.:Int64, json.d.b.:Date from test order by id format Null;
select json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.d.b, json.d.b.:Int64, json.d.b.:Date from test order by id format Null;
select json, json.b.b.e, json.d.a, json.d.b from test order by id format Null;
select json, json.b.b.e.:String, json.b.b.e.:Date, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.d.b.:Int64, json.d.b.:Date from test order by id format Null;
select json, json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.d.b, json.d.b.:Int64, json.d.b.:Date from test format Null;
select json, json.b.b.e, json.b.b.e.:String, json.b.b.e.:Date, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.d.b, json.d.b.:Int64, json.d.b.:Date from test order by id format Null;

select count() from test where json.d.a is Null and json.d.b is Null;
select count() from test where empty(json.d.a.:`Array(Nullable(Int64))`) and json.d.b.:Int64 is Null;
select json.d.a, json.d.b from test order by id format Null;
select json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.d.b.:Int64, json.d.b.:Date from test order by id format Null;
select json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.d.b, json.d.b.:Int64, json.d.b.:Date from test order by id format Null;
select json, json.d.a, json.d.b from test order by id format Null;
select json, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.d.b.:Int64, json.d.b.:Date from test order by id format Null;
select json, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.d.b, json.d.b.:Int64, json.d.b.:Date from test format Null;
select json, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.d.b, json.d.b.:Int64, json.d.b.:Date from test order by id format Null;

select count() from test where json.d.a is Null and json.b.b.`_1` is Null;
select count() from test where empty(json.d.a.:`Array(Nullable(Int64))`) and json.b.b.`_1`.:Int64 is Null;
select json.d.a, json.b.b.`_1` from test order by id format Null;
select json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.b.b.`_1`.:Int64, json.b.b.`_1`.:Date from test order by id format Null;
select json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.b.b.`_1`.:Int64, json.b.b, json.b.b.`_1`.:Date from test order by id format Null;
select json, json.d.a, json.b.b.`_1` from test order by id format Null;
select json, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.b.b.`_1`.:Int64, json.b.b.`_1`.:Date from test order by id format Null;
select json, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.b.b.`_1`.:Int64, json.b.b, json.b.b.`_1`.:Date from test format Null;
select json, json.d.a, json.d.a.:`Array(Nullable(Int64))`, json.d.a.:Date, json.b.b.`_1`.:Int64, json.b.b, json.b.b.`_1`.:Date from test order by id format Null;

select count() from test where JSONEmpty(json.^a) and json.a.b.c == 0;
select json.^a, json.a.b.c from test order by id format Null;
select json, json.^a, json.a.b.c from test format Null;
select json, json.^a, json.a.b.c from test order by id format Null;

select count() from test where JSONEmpty(json.^a) and json.a.b.d is Null;
select json.^a, json.a.b.d from test order by id format Null;
select json.^a, json.a.b.d.:Int64, json.a.b.d.:Date from test order by id format Null;
select json.^a, json.a.b.d, json.a.b.d.:Int64, json.a.b.d.:Date from test order by id format Null;
select json, json.^a, json.a.b.d from test order by id format Null;
select json, json.^a, json.a.b.d.:Int64, json.a.b.d.:Date from test order by id format Null;
select json, json.^a, json.a.b.d, json.a.b.d.:Int64, json.a.b.d.:Date from test format Null;
select json, json.^a, json.a.b.d, json.a.b.d.:Int64, json.a.b.d.:Date from test order by id format Null;

drop table test;
