package org.pacman.tpcds

import org.apache.spark.sql.SparkSession

object ThroughputTest {
  def main(args: Array[String]): Unit = {
    val it = args.iterator
    val queriesDir = it.next()
    val DB = it.next()
    val sessionIdFrom = it.next().toInt
    val sessionIdTo = it.next().toInt

    val spark = SparkSession
      .builder()
      .appName(getClass.getName)
      .enableHiveSupport()
      .getOrCreate()

    val threadPool = java.util.concurrent.Executors.newFixedThreadPool(sessionIdTo - sessionIdFrom + 1)

    val futures = (sessionIdFrom to sessionIdTo).map(sessId => {
      threadPool.submit(new Runnable {
        override def run(): Unit = {
          val sess = spark.newSession()
          sess.sql(s"use ${DB}")
          val path = s"${queriesDir}/query_${sessId}.sql"
          // read path, split by ";"
          val queries = scala.io.Source.fromFile(path).mkString.split(";")
          // for each line, sqlContext.sql(line)
          queries.zipWithIndex.foreach { case (query, i) =>
            println(s"Testing: \n${query}")
            val df = sess.sql(query)
            Utility.writeCsvFile(df, s"tp_${sessId}_${i}.csv")
          }
        }
      })
    }).toArray
    futures.foreach(_.get())
  }
}
