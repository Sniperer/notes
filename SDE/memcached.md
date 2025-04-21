# memcached
memcached是开源的分布式内存对象缓存系统。基于内存的key-value存储，用来存储小块的任意数据（字符串，对象）。这些数据可以是数据库调用、API调用或者是页面渲染的结果。一般使用的目的是，通过缓存数据库查询结果，减少数据库访问次数，以提高动态web应用的速度、提高可扩展性。

## 基本命令
+ set

  将value储存在指定的key值，如果set的key已存在，该命令可以更新。成功输出STORED，失败输出ERROR。
  <code>
set key flags exptime bytes [noreply] <br>
value
</code>

  > key: 用于查找缓存值 <br>
  > flags: 可以包含键值对的整型参数，客户机使用它存储关于键值对的额外信息 <br>
  > exptime: 在缓存中保存键值对的时间长度，以秒为单位，0代表永久 <br>
  > bytes: 在缓存中储存的字节数 <br>
  > noreply: 告知服务器不需要返回数据 <br>
  > value: 存储的值，始终位于第二行 <br>

+ add

  如果add的key已经存在，则不会更新数据（过期的key会更新），之前的值仍然保持相同，并且获得响应NOT_STORED
  <code>
add key flags exptime bytes [noreply] <br>
value
  </code>

+ replace

  用于替换已存在的key的value值，如果key不存在就替换失败，并且获得响应NOT_STORED
  <code>
replace key flags exptime bytes [noreply] <br>
value
  </code>

  | 方法 | key存在时 | key不存在时 |
|---|---|---|
| add | false | true |
| replace | true | false |
| set | true | true |

+ append

  用于向已存在key的value后追加数据。如果key不存在返回NOT_STORED, 执行错误返回CLIENT_ERROR。
  <code>
append key flags exptime bytes [noreply] <br>
value
  </code>

+ prepend

  用于向已存在key的value前追加数据。
  <code>
  prepend key flags exptime bytes [noreply]
  value
  </code>

+ CAS

  用于执行一个检查并设置的操作，仅在客户端最后一次取值后，该key对应的值没有被其他客户端修改的情况下，才能够将值写入，检查是通过cas_token参数进行的，这个参数是Memcach指定给已经存在的元素的一个唯一的64位值。STORED保存成功输出，ERROR保存出错或语法出错，EXISTS在最后一次取值之后另外一个用户也在更新该数据，NOT_FOUND,memcached服务上b不存在该键值。
  <code>
  cas key flags exptime bytes unique_cas_token [noreply] <br>
  value
  </code>

  > unique_cas_token: 通过gets命令获得一个唯一的64位值

+ get

  获取储存在key中的value，如果key不存在，则返回空。
  get key1 key2 key3

+ gets

  获取带有CAS令牌存的value，如果key不存在，则返回空。
  与get命令语法一样。

+ delete

  用于删除已存在的key。DELETED: 删除成功，ERROR: 语法错误或删除失败，NOT_FOUND: key不存在。
  delete key [noreply]

+ incr和decr

  用于对已存在的key的数字值进行自增或自减操作，incr和decr命令操作的数据必须是十进制的32位无符号整数。如果key不存在返回NOT_FOUND, 如果键的值不为数字，则返回CLIENT_ERROR,其他错误返回ERROR。increment_value表示增加的数值。
  incr key increment_value

+ stats

  用于返回统计信息例如PID、版本号、连接数等。
