# Correct outputs

    Code
      start <- lubridate::make_date(1999, 4, 1)
      end <- lubridate::make_date(2100, 3, 31)
      dates <- seq(start, end, by = "day")
      df <- data.frame(date = dates, fin_year = extract_fin_year(dates))
      dplyr::summarise(df, first_date = min(date), last_date = max(date), days = dplyr::n(),
      .by = fin_year)
    Output
          fin_year first_date  last_date days
      1    1999/00 1999-04-01 2000-03-31  366
      2    2000/01 2000-04-01 2001-03-31  365
      3    2001/02 2001-04-01 2002-03-31  365
      4    2002/03 2002-04-01 2003-03-31  365
      5    2003/04 2003-04-01 2004-03-31  366
      6    2004/05 2004-04-01 2005-03-31  365
      7    2005/06 2005-04-01 2006-03-31  365
      8    2006/07 2006-04-01 2007-03-31  365
      9    2007/08 2007-04-01 2008-03-31  366
      10   2008/09 2008-04-01 2009-03-31  365
      11   2009/10 2009-04-01 2010-03-31  365
      12   2010/11 2010-04-01 2011-03-31  365
      13   2011/12 2011-04-01 2012-03-31  366
      14   2012/13 2012-04-01 2013-03-31  365
      15   2013/14 2013-04-01 2014-03-31  365
      16   2014/15 2014-04-01 2015-03-31  365
      17   2015/16 2015-04-01 2016-03-31  366
      18   2016/17 2016-04-01 2017-03-31  365
      19   2017/18 2017-04-01 2018-03-31  365
      20   2018/19 2018-04-01 2019-03-31  365
      21   2019/20 2019-04-01 2020-03-31  366
      22   2020/21 2020-04-01 2021-03-31  365
      23   2021/22 2021-04-01 2022-03-31  365
      24   2022/23 2022-04-01 2023-03-31  365
      25   2023/24 2023-04-01 2024-03-31  366
      26   2024/25 2024-04-01 2025-03-31  365
      27   2025/26 2025-04-01 2026-03-31  365
      28   2026/27 2026-04-01 2027-03-31  365
      29   2027/28 2027-04-01 2028-03-31  366
      30   2028/29 2028-04-01 2029-03-31  365
      31   2029/30 2029-04-01 2030-03-31  365
      32   2030/31 2030-04-01 2031-03-31  365
      33   2031/32 2031-04-01 2032-03-31  366
      34   2032/33 2032-04-01 2033-03-31  365
      35   2033/34 2033-04-01 2034-03-31  365
      36   2034/35 2034-04-01 2035-03-31  365
      37   2035/36 2035-04-01 2036-03-31  366
      38   2036/37 2036-04-01 2037-03-31  365
      39   2037/38 2037-04-01 2038-03-31  365
      40   2038/39 2038-04-01 2039-03-31  365
      41   2039/40 2039-04-01 2040-03-31  366
      42   2040/41 2040-04-01 2041-03-31  365
      43   2041/42 2041-04-01 2042-03-31  365
      44   2042/43 2042-04-01 2043-03-31  365
      45   2043/44 2043-04-01 2044-03-31  366
      46   2044/45 2044-04-01 2045-03-31  365
      47   2045/46 2045-04-01 2046-03-31  365
      48   2046/47 2046-04-01 2047-03-31  365
      49   2047/48 2047-04-01 2048-03-31  366
      50   2048/49 2048-04-01 2049-03-31  365
      51   2049/50 2049-04-01 2050-03-31  365
      52   2050/51 2050-04-01 2051-03-31  365
      53   2051/52 2051-04-01 2052-03-31  366
      54   2052/53 2052-04-01 2053-03-31  365
      55   2053/54 2053-04-01 2054-03-31  365
      56   2054/55 2054-04-01 2055-03-31  365
      57   2055/56 2055-04-01 2056-03-31  366
      58   2056/57 2056-04-01 2057-03-31  365
      59   2057/58 2057-04-01 2058-03-31  365
      60   2058/59 2058-04-01 2059-03-31  365
      61   2059/60 2059-04-01 2060-03-31  366
      62   2060/61 2060-04-01 2061-03-31  365
      63   2061/62 2061-04-01 2062-03-31  365
      64   2062/63 2062-04-01 2063-03-31  365
      65   2063/64 2063-04-01 2064-03-31  366
      66   2064/65 2064-04-01 2065-03-31  365
      67   2065/66 2065-04-01 2066-03-31  365
      68   2066/67 2066-04-01 2067-03-31  365
      69   2067/68 2067-04-01 2068-03-31  366
      70   2068/69 2068-04-01 2069-03-31  365
      71   2069/70 2069-04-01 2070-03-31  365
      72   2070/71 2070-04-01 2071-03-31  365
      73   2071/72 2071-04-01 2072-03-31  366
      74   2072/73 2072-04-01 2073-03-31  365
      75   2073/74 2073-04-01 2074-03-31  365
      76   2074/75 2074-04-01 2075-03-31  365
      77   2075/76 2075-04-01 2076-03-31  366
      78   2076/77 2076-04-01 2077-03-31  365
      79   2077/78 2077-04-01 2078-03-31  365
      80   2078/79 2078-04-01 2079-03-31  365
      81   2079/80 2079-04-01 2080-03-31  366
      82   2080/81 2080-04-01 2081-03-31  365
      83   2081/82 2081-04-01 2082-03-31  365
      84   2082/83 2082-04-01 2083-03-31  365
      85   2083/84 2083-04-01 2084-03-31  366
      86   2084/85 2084-04-01 2085-03-31  365
      87   2085/86 2085-04-01 2086-03-31  365
      88   2086/87 2086-04-01 2087-03-31  365
      89   2087/88 2087-04-01 2088-03-31  366
      90   2088/89 2088-04-01 2089-03-31  365
      91   2089/90 2089-04-01 2090-03-31  365
      92   2090/91 2090-04-01 2091-03-31  365
      93   2091/92 2091-04-01 2092-03-31  366
      94   2092/93 2092-04-01 2093-03-31  365
      95   2093/94 2093-04-01 2094-03-31  365
      96   2094/95 2094-04-01 2095-03-31  365
      97   2095/96 2095-04-01 2096-03-31  366
      98   2096/97 2096-04-01 2097-03-31  365
      99   2097/98 2097-04-01 2098-03-31  365
      100  2098/99 2098-04-01 2099-03-31  365
      101  2099/00 2099-04-01 2100-03-31  365
