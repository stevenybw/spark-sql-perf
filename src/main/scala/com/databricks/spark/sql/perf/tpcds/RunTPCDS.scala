package com.databricks.spark.sql.perf.tpcds

import org.apache.spark.sql.SparkSession

object RunTPCDS {
  // Adapted from "tpcds_run" script provided by spark-sql-perf
  def main(args: Array[String]): Unit = {
    val scaleFactor = "1"
    val codec = "snappy"
    val metastoreURI = "thrift://master:9083"
    val dsdgenDir = "/root/tpcds-kit/tools"
    val warehousePath = "hdfs://master/user/root/tpcds_warehouse"
    val format = "parquet"
    val useDecimal = true
    val useDate = true
    val filterNull = false
    val shuffle = true
    val rootDir = s"${warehousePath}/sf$scaleFactor-$format/useDecimal=$useDecimal,useDate=$useDate,filterNull=$filterNull,compression=$codec"
    val databaseName = s"tpcds_sf${scaleFactor}" +
      s"""_${if (useDecimal) "with" else "no"}decimal""" +
      s"""_${if (useDate) "with" else "no"}date""" +
      s"""_${if (filterNull) "no" else "with"}nulls""" +
      s"""_${codec}"""
    val spark = SparkSession.builder()
      .config("hive.metastore.warehouse.dir", warehousePath)
      .config("hive.metastore.uris", metastoreURI)
      .config("spark.memory.offHeap.enabled", "true")
      .config("spark.memory.offHeap.size", "2g")
      .enableHiveSupport()
      .getOrCreate()
    val sqlContext = spark.sqlContext

    val iterations = 2 // how many times to run the whole set of queries.
    val timeout = 60 // timeout in hours

    val query_filter = Seq() // Seq() == all queries
    //val query_filter = Seq("q1-v2.4", "q2-v2.4") // run subset of queries
    val randomizeQueries = false // run queries in a random order. Recommended for parallel runs.

    // detailed results will be written as JSON to this location.
    val resultLocation = "/root/performance-datasets/tpcds/results"

    // COMMAND ----------

    // Spark configuration
    spark.conf.set("spark.sql.broadcastTimeout", "10000") // good idea for Q14, Q88.

    // ... + any other configuration tuning

    // COMMAND ----------

    spark.sql(s"use $databaseName")

    // COMMAND ----------

    import com.databricks.spark.sql.perf.tpcds.TPCDS

    val tpcds = new TPCDS(sqlContext = sqlContext)

    def queries = {
      val filtered_queries = query_filter match {
        case Seq() => tpcds.tpcds2_4Queries
        case _ => tpcds.tpcds2_4Queries.filter(q => query_filter.contains(q.name))
      }
      if (randomizeQueries) scala.util.Random.shuffle(filtered_queries) else filtered_queries
    }

    val experiment = tpcds.runExperiment(
      queries,
      iterations = iterations,
      resultLocation = resultLocation,
      tags = Map("runtype" -> "benchmark", "database" -> databaseName, "scale_factor" -> scaleFactor))

    println(experiment.toString)
    experiment.waitForFinish(timeout * 60 * 60)
  }
}
