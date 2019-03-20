groupLabels <<- tibble( # Labels of the test series
  group = c("ta001", "ta002", "ta003", "ta004", "ta005", "ta006", "ta007", "ta008",
            "0004", "0005", "0006", "0007", "0008", "0009", "0010", "0011", "0012", "0013", "0014",
            
            "0020",
            "0021", "0022", "0023", "0024", "0025", "0026", "0027", "0028",
            "0031", "0032", "0033", "0034", "0035", "0036", "0037", "0038",
            "0041", "0042", "0046", "0047",
            "0051", "0052", "0056", "0057",
            
            "0060",
            "0061", "0062", "0063", "0064",
            "0065", "0066", "0067", "0068",
            "0071", "0072", "0073", "0074",
            "0075", "0076", "0077", "0078"),
  groupLabel = c("Product: SecQL", "Product: HL", "Product: HL & OL", "Product: HL & OL & Sel", "Sum: SecQL", "Sum: HL", "Sum: HL & OL", "Sum: HL & OL & Sel",
                 "Client Only", "Privacy Disabled", "Privacy Aware", "SecQL NoPriv", "SecQL PrivAware", "Product NoPriv", "Product PrivAware", "Sum NoPriv", "Sum PrivAware", "Selectivity Sum NoPriv", "Selectivity Sum PrivAware",
                 "Client Only",  # 0020, ...
                 "0SecQL (NoPriv, Prod)", "1HL (NoPriv, Prod)", "2HL+OL (NoPriv, Prod)", "3HL+OL+Sel (NoPriv, Prod)",# 0021, ...
                 "0SecQL (NoPriv, Sum)", "1HL (NoPriv, Sum)", "2HL+OL (NoPriv, Sum)", "3HL+OL+Sel (NoPriv, Sum)",
                 "0SecQL (PrivAw, Prod)", "1HL (PrivAw, Prod)", "2HL+OL (PrivAw, Prod)", "3HL+OL+Sel (PrivAw, Prod)", # 0031, ...
                 "0SecQL (PrivAw, Sum)", "1HL (PrivAw, Sum)", "2HL+OL (PrivAw, Sum)", "3HL+OL+Sel (PrivAw, Sum)",
                 "4HL+OL+EvSel (NoPriv, Prod)", "5SecQL+EvSel (NoPriv, Prod)", # 0054, ...
                 "4HL+OL+EvSel (NoPriv, Sum)", "5SecQL+EvSel (NoPriv, Sum)",
                 "4HL+OL+EvSel (PrivAw, Prod)", "5SecQL+EvSel (PrivAw, Prod)", # 0051, ...
                 "4HL+OL+EvSel (PrivAw, Sum)", "5SecQL+EvSel (PrivAw, Sum)",
                 
                 "Client Only",
                 
                 "SecQL (NoPriv, Prod)", "SecQL+EvSel (NoPriv, Prod)", "HL+OL (NoPriv, Prod)", "HL+OL+EvSel (NoPriv, Prod)",
                 "SecQL (NoPriv, Sum)", "SecQL+EvSel (NoPriv, Sum)", "HL+OL (NoPriv, Sum)", "HL+OL+EvSel (NoPriv, Sum)",
                 "SecQL (PrivAw, Prod)", "SecQL+EvSel (PrivAw, Prod)", "HL+OL (PrivAw, Prod)", "HL+OL+EvSel (PrivAw, Prod)",
                 "SecQL (PrivAw, Sum)", "SecQL+EvSel (PrivAw, Sum)", "HL+OL (PrivAw, Sum)", "HL+OL+EvSel (PrivAw, Sum)"),
  
  costFunction = c("5secqlProd", "5hlProd", "5hlOlProd", "5hlOlProd", "5secqlSum", "5hlSum", "5hlOlSum", "5hlOlSum",
                   "1secql", "1secql", "1secql", "2secql", "2secql", "3prod", "3prod", "3sum", "3sum", "4sum", "4sum",
                   
                   "trivial",
                   "5secqlProd", "5hlProd", "5hlOlProd", "5hlOlProd", "5secqlSum", "5hlSum", "5hlOlSum", "5hlOlSum",
                   "5secqlProd", "5hlProd", "5hlOlProd", "5hlOlProd", "5secqlSum", "5hlSum", "5hlOlSum", "5hlOlSum",
                   "5hlOlProd", "5secqlProd", "5hlOlSum", "5secqlSum",
                   "5hlOlProd", "5secqlProd", "5hlOlSum", "5secqlSum",
                   
                   "trivial",
                   "5secqlProd", "5secqlProd","5hlOlProd", "5hlOlProd",
                   "5secqlSum", "5secqlSum", "5hlOlSum", "5hlOlSum",
                   "5secqlProd", "5secqlProd","5hlOlProd", "5hlOlProd",
                   "5secqlSum", "5secqlSum", "5hlOlSum", "5hlOlSum"),
  
  selectivity = c("est", "est", "est", "rec", "est", "est", "est", "rec",
                  "est", "est", "est", "est", "est", "est", "est", "est", "est", "est", "est",
                  
                  "est",
                  "est", "est", "est", "rec", "est", "est", "est", "rec",
                  "est", "est", "est", "rec", "est", "est", "est", "rec",
                  "event", "event", "event", "event",
                  "event", "event", "event", "event",
                  
                  "est",
                  "est", "event", "est", "event",
                  "est", "event", "est", "event",
                  "est", "event", "est", "event",
                  "est", "event", "est", "event"),
  
  resources = c("homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222",
                "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222",
                "homo122222",
                "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222",
                "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222", "homo122222",
                "homo122222", "homo122222", "homo122222", "homo122222",
                "homo122222", "homo122222", "homo122222", "homo122222",
                
                "hetero141120.5",
                "hetero141120.5", "hetero141120.5", "hetero141120.5", "hetero141120.5",
                "hetero141120.5", "hetero141120.5", "hetero141120.5", "hetero141120.5",
                "hetero141120.5", "hetero141120.5", "hetero141120.5", "hetero141120.5",
                "hetero141120.5", "hetero141120.5", "hetero141120.5", "hetero141120.5"),
  
  placement = c("optimal", "optimal", "optimal", "optimal", "optimal", "optimal", "optimal", "optimal",
                "client-only", "optimal", "private", "optimal", "private", "optimal", "private", "optimal", "private", "optimal", "private",
                
                "client-only",
                "optimal", "optimal", "optimal", "optimal", "optimal", "optimal", "optimal", "optimal",
                "private", "private", "private", "private", "private", "private", "private", "private",
                "optimal", "optimal", "optimal", "optimal",
                "private", "private", "private", "private",
                
                "client-only",
                "optimal", "optimal", "optimal", "optimal",
                "optimal", "optimal", "optimal", "optimal",
                "private", "private", "private", "private",
                "private", "private", "private", "private"))