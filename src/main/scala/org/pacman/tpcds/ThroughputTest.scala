package org.pacman.tpcds

import org.apache.spark.sql.SparkSession
import org.pacman.tpcds.Utility.executePhase

object ThroughputTest {
  def main(args: Array[String]): Unit = {
    val it = args.iterator
    val queriesDir = it.next()
    val DB = it.next()
    val sessionIdFrom = it.next().toInt
    val sessionIdTo = it.next().toInt

    executePhase(DB, "ThroughputTest") {
      val spark = Utility.createSparkSession(getClass.getName)
      spark.sql(s"use ${DB}")

      val threadPool = java.util.concurrent.Executors.newFixedThreadPool(sessionIdTo - sessionIdFrom + 1)

      val futures = (sessionIdFrom to sessionIdTo).map(sessId => {
        threadPool.submit(new Runnable {
          override def run(): Unit = {
            Utility.loadQueries(queriesDir, sessId).zipWithIndex.foreach { case (query, i) =>
              println(s"Testing: \n${query}")
              val df = spark.sql(query)
              Utility.writeCsvFile(df, s"tp_${sessId}_${i}.csv")
            }
          }
        })
      }).toArray
      futures.foreach(_.get())
      threadPool.shutdown()
    }
  }
}
