# Output is identical over time

    Code
      file_size(test_path("files"))
    Output
      # A tibble: 8 x 2
        name             size       
        <chr>            <chr>      
      1 airquality.xls   Excel 26 kB
      2 bod.xlsx         Excel 5 kB 
      3 iris.csv         CSV 4 kB   
      4 mtcars.sav       SPSS 4 kB  
      5 plant-growth.rds RDS 316 B  
      6 puromycin.txt    Text 442 B 
      7 stackloss.fst    FST 897 B  
      8 swiss.tsv        TSV 1 kB   

---

    Code
      file_size(test_path("files"), "xlsx?")
    Output
      # A tibble: 2 x 2
        name           size       
        <chr>          <chr>      
      1 airquality.xls Excel 26 kB
      2 bod.xlsx       Excel 5 kB 

