package org.apache.spark.application

import org.apache.spark.sql.SparkSession

object GenerateDataset {
  def main(args: Array[String]): Unit = {
    val ait = args.iterator
    val scaleFactor = ait.next()
    val codec = if (ait.hasNext) {
      ait.next()
    } else {
      "snappy"
    }
    val rawPrefixPath = if (ait.hasNext) {
      ait.next()
    } else {
      "hdfs://bic07/user/ybw/ssd/tpcds_gen"
    }
    val warehousePrefixPath = if (ait.hasNext) {
      ait.next()
    } else {
      "hdfs://bic07/user/ybw/tpcds_warehouse"
    }
    val storageDevice = if (ait.hasNext) {
      ait.next()
    } else {
      "hdd"
    }
    println(s"SF = ${scaleFactor.toInt}")
    println(s"Compression_Codec = ${codec}")
    println(s"Raw_Prefix_Path = ${rawPrefixPath}")
    println(s"Warehouse_Prefix_Path = ${warehousePrefixPath}")
    println(s"Storage_Device = ${storageDevice}")

    val spark = SparkSession.builder()
      .config("hive.metastore.warehouse.dir", warehousePrefixPath)
      .config("hive.metastore.uris", "thrift://bic08:9083")
      .config("spark.memory.offHeap.enabled", "true")
      .config("spark.memory.offHeap.size", "2g")
      .enableHiveSupport()
      .getOrCreate()
    val sqlContext = spark.sqlContext

    val format = "parquet"
    val useDecimal = true
    val useDate = true
    val filterNull = false
    val shuffle = true

    val rootDir = s"${rawPrefixPath}/sf$scaleFactor-$format/useDecimal=$useDecimal,useDate=$useDate,filterNull=$filterNull,compression=$codec"
    val databaseName = s"tpcds_sf${scaleFactor}" +
      s"""_${if (useDecimal) "with" else "no"}decimal""" +
      s"""_${if (useDate) "with" else "no"}date""" +
      s"""_${if (filterNull) "no" else "with"}nulls_${storageDevice}""" +
      s"""_${codec}"""

    import com.databricks.spark.sql.perf.tpcds.TPCDSTables
    val tables = new TPCDSTables(sqlContext, dsdgenDir = "/home/ybw/OpenSourceCode/tpcds-kit/tools", scaleFactor = scaleFactor, useDoubleForDecimal = !useDecimal, useStringForDate = !useDate)

    import org.apache.spark.deploy.SparkHadoopUtil
    // Limit the memory used by parquet writer
    SparkHadoopUtil.get.conf.set("parquet.memory.pool.ratio", "0.1")
    // Compress with snappy:
    sqlContext.setConf("spark.sql.parquet.compression.codec", codec)
    // TPCDS has around 2000 dates.
    spark.conf.set("spark.sql.shuffle.partitions", "2000")
    // Don't write too huge files.
    sqlContext.setConf("spark.sql.files.maxRecordsPerFile", "20000000")

    val dsdgen_partitioned = if (scaleFactor.toInt <= 1000) {
      1000
    } else {
      10000
    } // recommended for SF10000+.
    println(s"Number of partitions = ${dsdgen_partitioned}")
    val dsdgen_nonpartitioned = 10 // small tables do not need much parallelism in generation.

    // Note: customer 3.3GB  customer_address 0.6GB
    val nonPartitionedTables = Array("call_center", "catalog_page", "customer", "customer_address", "customer_demographics", "date_dim", "household_demographics", "income_band", "item", "promotion", "reason", "ship_mode", "store", "time_dim", "warehouse", "web_page", "web_site")
    nonPartitionedTables.foreach { t => {
      tables.genData(
        location = rootDir,
        format = format,
        overwrite = true,
        partitionTables = true,
        clusterByPartitionColumns = shuffle,
        filterOutNullPartitionValues = filterNull,
        tableFilter = t,
        numPartitions = dsdgen_nonpartitioned)
    }
    }
    println("Done generating non partitioned tables.")

    // leave the biggest/potentially hardest tables to be generated last.
    val partitionedTables = Array("inventory", "web_returns", "catalog_returns", "store_returns", "web_sales", "catalog_sales", "store_sales")
    partitionedTables.foreach { t => {
      tables.genData(
        location = rootDir,
        format = format,
        overwrite = true,
        partitionTables = true,
        clusterByPartitionColumns = shuffle,
        filterOutNullPartitionValues = filterNull,
        tableFilter = t,
        numPartitions = dsdgen_partitioned)
    }
    }
    println("Done generating partitioned tables.")

    import spark.sql

    sql(s"drop database if exists $databaseName cascade")
    sql(s"create database $databaseName")
    sql(s"use $databaseName")
    tables.createExternalTables(rootDir, format, databaseName, overwrite = true, discoverPartitions = true)
    tables.analyzeTables(databaseName, analyzeColumns = true)
  }
}
