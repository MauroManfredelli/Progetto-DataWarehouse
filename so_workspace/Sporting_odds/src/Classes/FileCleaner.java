package Classes;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.PrintWriter;
import java.lang.Exception;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Locale;

public class FileCleaner extends Maker {
		private String matches_esdb, teams_esdb, teams_esdb_cleaned, countries_esdb, countries_esdb_cleaned, max_date_file, leagues_esdb, leagues_esdb_cleaned, portion_map_file;
		private LocalDate max_date;
		private DateTimeFormatter formatter;
		private HashMap<String,String> portion_map;
		
		public FileCleaner () {
			max_date_file = etl_path + "created/max_date.csv";
			max_date = null;
			formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy", Locale.ITALIAN);
			matches_esdb = esdb_path + "matches_esdb.csv";
			countries_esdb = esdb_path + "countries_esdb.csv";
			countries_esdb_cleaned = etl_path + "countries_esdb_cleaned.csv";
			leagues_esdb = esdb_path + "leagues_esdb.csv";
			leagues_esdb_cleaned = etl_path + "leagues_esdb_cleaned.csv";
			teams_esdb = esdb_path + "teams_esdb.csv";
			teams_esdb_cleaned = etl_path + "teams_esdb_cleaned.csv";
			portion_map = new HashMap<String,String>();
			portion_map_file = etl_path +"created/portion_tennis.csv";
			
			take_max_date();
			
			clean_matches_esdb();
			clean_teams_esdb(teams_esdb, teams_esdb_cleaned);
			clean_countries_esdb(countries_esdb, countries_esdb_cleaned);
			clean_leagues_esdb(leagues_esdb, leagues_esdb_cleaned);
			System.out.println("\tESDB cleaned");
			
			clean_fd();
			clean_fd_div();
			System.out.println("\tFD cleaned");
			
			make_portion_map();
			
			clean_atpmt();
			System.out.println("\tATPMT cleaned");
			
			clean_td();
			System.out.println("\tTD cleaned");
			
			clean_atpmds();
			System.out.println("\tATPMDS cleaned");
			
			clean_countries();
			System.out.println("\tCountries cleaned");
			
			clean_cities();
			System.out.println("\tCities cleaned");
		}
		
		public void take_max_date () {
			try {
				BufferedReader br = new BufferedReader(new FileReader(max_date_file));
				String d = br.readLine();
				if (d==null || d.equals(""))
					max_date = LocalDate.parse("31/12/2007", formatter);
				else {
					d = d.substring(8) + "/" + d.substring(5, 7) +"/" + d.substring(0,4);
					max_date = LocalDate.parse(d, formatter);
				}
				br.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		
		public void make_portion_map () {
			try {
				BufferedReader br = new BufferedReader (new FileReader(portion_map_file));
				String line = br.readLine();
				while ((line = br.readLine())!=null) {
					String [] cols = line.split(csvSplitBy);
					portion_map.put(cols[0], cols[1]);
				}
				br.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		public void clean (String file_read, String file_write) {
			try {
				BufferedReader br = new BufferedReader (new FileReader(file_read));
				PrintWriter wr = new PrintWriter (new File(file_write));
				String line = br.readLine();
				wr.append(line+"\n");
				while ((line=br.readLine())!=null) {
					String [] cols = line.split(csvSplitBy);
					if (cols.length>0) {
						int i;
						for (i=0; i<cols.length-1; i++) {
							cols[i]=clean_str(cols[i]);
							wr.append(cols[i]+",");
						}
						cols[i]=clean_str(cols[i]);
						wr.append(cols[i]+"\n");
					}
				}				
				br.close();
				wr.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		public void clean_teams_esdb (String file_read, String file_write) {
			try {
				BufferedReader br = new BufferedReader (new FileReader(file_read));
				PrintWriter wr = new PrintWriter (new File(file_write));
				PrintWriter wr1 = new PrintWriter (new File(etl_path+"teams_esdb_double.csv"));
				String line = br.readLine();
				HashMap <String, String> map = new HashMap <String, String>();
				wr.append(line+"\n");
				wr1.append("right,wrong\n");
				while ((line=br.readLine())!=null) {
					String [] cols = line.split(csvSplitBy);
					if (cols.length>0) {
						String name = clean_str(cols[3]);
						if (!map.containsKey(name)) {
							map.put(name, clean_str(cols[1]));
							int i;
							for (i=0; i<cols.length-1; i++) {
								cols[i]=clean_str(cols[i]);
								wr.append(cols[i]+",");
							}
							cols[i]=clean_str(cols[i]);
							wr.append(cols[i]+"\n");
						} else {
							wr1.append(map.get(name)+","+cols[1]+"\n");
						}
					}
				}				
				br.close();
				wr.close();
				wr1.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		public void clean_fd_div () {
			try {
				BufferedReader br = new BufferedReader (new FileReader(fd_div));
				PrintWriter wr = new PrintWriter (new File(cleaned_fd_div));
				String line = br.readLine();
				wr.append(line+"\n");
				while ((line=br.readLine())!=null) {
					String [] cols = line.split(csvSplitBy);
					if (cols.length>0) {
						String name = clean_str(cols[2]);
						if (name.equals("Scotland") || name.equals("England"))
							name = "United Kingdom of Great Britain and Northern Ireland";
						wr.append(clean_str(cols[0])+","+clean_str(cols[1])+","+name+"\n");
					}
				}				
				br.close();
				wr.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		public void clean_countries_esdb (String file_read, String file_write) {
			try {
				BufferedReader br = new BufferedReader (new FileReader(file_read));
				PrintWriter wr = new PrintWriter (new File(file_write));
				String line = br.readLine();
				wr.append(line+"\n");
				while ((line=br.readLine())!=null) {
					String [] cols = line.split(csvSplitBy);
					if (cols.length>0) {
						String name = clean_str(cols[1]);
						wr.append(clean_str(cols[0])+","+name+"\n");
					}
				}				
				br.close();
				wr.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		public void clean_leagues_esdb (String file_read, String file_write) {
			try {
				BufferedReader br = new BufferedReader (new FileReader(file_read));
				PrintWriter wr = new PrintWriter (new File(file_write));
				String line = br.readLine();
				wr.append(line+"\n");
				while ((line=br.readLine())!=null) {
					String [] cols = line.split(csvSplitBy);
					if (cols.length>0) {
						String name = clean_str(cols[2]);
						if (name.equals("Scotland Premier League"))
							name = "Scotland Scottish Premier League";
						wr.append(clean_str(cols[0])+","+clean_str(cols[1])+","+name+"\n");
					}
				}				
				br.close();
				wr.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		private void clean_matches_esdb () {
			String line="";
			try {
				BufferedReader br = new BufferedReader(new FileReader(matches_esdb));
		        PrintWriter wr = new PrintWriter(new File(cleaned_esdb));
		        line = br.readLine();
		        String [] cols = line.split(csvSplitBy);
		        put(wr, cols, 0, 3, false);
		        wr.append("portion,");
		        put(wr, cols, 5, 10, false);
		        put(wr, cols, 85, 87, false);
		        put(wr, cols, 94, 96, false);
		        put(wr, cols, 97, 99, false);
		        put(wr, cols, 103, 105, true);
		        while ((line=br.readLine())!=null) {
		        	cols = line.split(csvSplitBy);
		        	if (cols.length>0 && !line.trim().substring(0,1).equals("<") && !line.trim().substring(0,1).equals("\"")) {
		        			String date = clean_str(cols[5]);
				        	cols[5] = date.substring(8, 10)+"/"+date.substring(5,7)+"/"+date.substring(0, 4);
				        	LocalDate d = LocalDate.parse(cols[5],formatter);
				        	if (d.compareTo(max_date)>0) {
				        		if (is_clean(cols, 0, 6) && is_clean(cols, 7, 10)) {
						        	put(wr, cols, 0, 3, false);
						        	if(d.getMonthValue()>=7 && d.getMonthValue()<=10)
						        		wr.append("1,");
						        	else
						        		wr.append("2,");
							        put(wr, cols, 5, 10, false);
							        if (cols.length>85 && is_clean(cols, 85, 87)) {
								        put(wr, cols, 85, 87, false);
								        if (cols.length>94 && is_clean(cols,94,96)) {
									        put(wr, cols, 94, 96, false);
									        if (cols.length>97 && is_clean(cols, 97, 99)) {
										        put(wr, cols, 97, 99, false);
										        if (cols.length>103 && is_clean(cols, 103, 105))
										        	put(wr, cols, 103, 105, true);
										        else 
										        	wr.append("\n");
									        } else 
									        	wr.append("\n");
								        } else 
								        	wr.append("\n");
							        } else 
							        	wr.append("\n");
				        		}
				        	}
		        	}
		        }
		        br.close();
		        wr.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		private boolean is_clean (String [] c, int i, int j) {
			for (int k=0; k<=j; k++) {
				if (c[k].contains("<") || c[k].contains(">"))
					return false;
			}
			return true;
		}
		
		public void clean_fd () {
			String path = root_path+"dataset\\Football-data\\dataset_originali\\";
			File folder = new File (path + "\\file");
			File [] list = folder.listFiles();
			HashMap <String, Integer> map = new HashMap <String,Integer> ();
			String [] bm = {"B365H","LBH","PSH","SJH"};
			try {
				BufferedReader br = new BufferedReader(new FileReader(path+"odds_map.csv"));
				PrintWriter wr = new PrintWriter(new File(cleaned_fd));
				String line = br.readLine();
				while ((line = br.readLine())!=null) {
					String [] cols = line.split(",");
					map.put(cols[0], Integer.parseInt(cols[1]));
				}
				br.close();
				int n_line=0;
				for (File f : list) {
					br = new BufferedReader(new FileReader(f.getPath()));
					line = br.readLine();
					String [] cols = line.split(",");
					int k = map.get(f.getName().substring(0,3));
					int i;
					HashMap <String, Integer> m = new HashMap<String, Integer> ();
					for (i=k; i<cols.length-3; i+=3) {
						String c = cols[i].trim();
						if (c.equals("B365H") || c.equals("LBH") || c.equals("PSH") || c.equals("SJH"))
							m.put(c, i);
					}
					if (n_line==0) {
						wr.append("id,");
						for (i=0; i<=5; i++)
							wr.append(clean_str(cols[i])+",");
						wr.append("season,portion,B365H,B365D,B365A,LBH,LBD,LBA,PSH,PSD,PSA,SJH,SJD,SJA\n");
					}
					while ((line = br.readLine())!=null) {
						//System.out.println(line+"*");
						cols = line.split(",");
						if (cols.length>0){
							String date = clean_str(cols[1]);
				        	String year = "";
				        	if (date.substring(6,7).equals("0") || date.substring(6,7).equals("1") || date.substring(6,7).equals("2"))
				        		year="20";
				        	else
				        		year="19";
				        	cols[1] = date.substring(0, 5)+"/"+year+date.substring(6,8);
				        	LocalDate d = LocalDate.parse(cols[1],formatter);
				        	if (d.compareTo(max_date)>0) {
				        		n_line++;
								wr.append(n_line+",");
								for (i=0; i<=5; i++)
									wr.append(clean_str(cols[i])+",");
								int month = d.getMonthValue();
					        	int y = d.getYear();
					        	if (month<7)
					        		wr.append((y-1)+"/"+(y)+",");
					        	else
					        		wr.append((y)+"/"+(y+1)+",");
					        	if (month>=7 && month<=10)
					        		wr.append("1,");
					        	else
					        		wr.append("2,");
								
								
								if (cols.length>k) {
									for (i=0; i<bm.length; i++) {
										if (m.containsKey(bm[i])) {
											int c = m.get(bm[i]);
											wr.append(clean_str(cols[c])+","+clean_str(cols[c+1])+","+clean_str(cols[c+2]));
										} else
											wr.append(",,");
										if (i+1<bm.length)
											wr.append(",");
										else
											wr.append("\n");
									}
								}
				        	}
						}			
					}
					br.close();
				}
				wr.close();
			} catch (Exception e) {
				e.printStackTrace();
			}			
		}
		
		private void put (PrintWriter wr, String [] cols, int i, int j, boolean end) {
			int k;
			if (!end)
				j+=1;
			for (k=i; k<j; k++)
				wr.append(clean_str(cols[k])+",");
			if (end)
				wr.append(clean_str(cols[k])+"\n");
		}
		
		private void clean_atpmt () {
			try {
				BufferedReader br = new BufferedReader(new FileReader(dataset_atpmt));
		        PrintWriter wr = new PrintWriter(new File(cleaned_atpmt));
		        String line = br.readLine();
		        wr.append("id,");
		        String [] cols = line.split(csvSplitBy);
		        put(wr, cols, 0, 3, false);
		        wr.append("season,portion,");
		        put(wr, cols, 9, 10, false);
		        put(wr, cols, 23, 24, false);
		        put(wr, cols, 34, 35, false);
		        put(wr, cols, 40, 41, false);
		        put(wr, cols, 46, 49, true);
		        int n_line=0;
		        while ((line=br.readLine())!=null) {
		        	cols = line.split(csvSplitBy);
		        	if (cols.length>0) {
			        	String date = clean_str(cols[3]);
			        	String [] date_ = date.split("/");
			        	String day = date_ [0];
			        	if (day.length()==1)
			        		day="0"+day;
			        	cols[3]=day+"/"+date_[1]+"/"+date_[2];
			        	LocalDate d = LocalDate.parse(cols[3],formatter);
			        	if (d.compareTo(max_date)>0) {
			        		n_line++;
				        	wr.append(n_line+",");
				        	cols [2] = clean_str_name(cols[2]);
				        	put(wr, cols, 0, 3, false);
				        	wr.append(d.getYear()+",");
					        wr.append(portion_map.get(cols[7])+",");
					        put(wr, cols, 9, 10, false);
					        if (cols.length>23) {
						        put(wr, cols, 23, 24, false);
						        if (cols.length>34) {
						        	put(wr, cols, 34, 35, false);
						        	if (cols.length>40) {
						        		put(wr, cols, 40, 41, false);
						        		if (cols.length>46){
						        			put(wr, cols, 45, 46, false);
						        			if (cols.length>48)
						        				put(wr, cols, 47, 48, true);
						        			else
						        				wr.append("\n");
						        		} else
					        				wr.append("\n");
						        	} else
				        				wr.append("\n");
						        } else
			        				wr.append("\n");
					        } else
		        				wr.append("\n");
			        	}
		        	}
		        }
		        br.close();
		        wr.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		private void clean_td () {
			String [] cols = null;
			String line = "";
			int n_line =0;
			try {
				BufferedReader br = new BufferedReader(new FileReader(dataset_td));
		        PrintWriter wr = new PrintWriter(new File(cleaned_td));
		        line = br.readLine();
		        wr.append("id,");
	        	cols = line.split(csvSplitBy);
	        	put(wr, cols, 0, 3, false);
		        wr.append("season,portion,");
		        put(wr, cols, 9, 10, false);
		        put(wr, cols, 25, 26, false);
		        put(wr, cols, 28, 29, false);
		        put(wr, cols, 32, 35, true);
		        while ((line=br.readLine())!=null) {
		        	cols = line.split(csvSplitBy);
		        	LocalDate d = null;
		        	if (cols.length>0)
		        			d = LocalDate.parse(cols[3], formatter);
		        	if(cols.length>0 && d.compareTo(max_date)>0) {
			        		n_line++;
				        	wr.append(n_line+",");
				        	cols[2]=clean_str_name(cols[2]);
			        		put(wr, cols, 0, 3, false);
			        		wr.append(d.getYear()+",");
			        		wr.append(portion_map.get(cols[7])+",");
					        put(wr, cols, 9, 10, false);
					        if (cols.length>25) {
						        put(wr, cols, 25, 26, false);
						        if (cols.length>28) {
						        	put(wr, cols, 28, 29, false);
						        	if (cols.length>32) {
						        		put(wr, cols, 32, 33, false);
						        		if (cols.length>34)
						        			put(wr, cols, 34, 35, true);
						        		else
						        			wr.append("\n");
						        	} else
					        			wr.append("\n");
						        } else
				        			wr.append("\n");
					        } else
			        			wr.append("\n");
		        	}
		        	line="";
		        }
		        br.close();
		        wr.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		public void clean_atpmds () {
			try {
				BufferedReader br = new BufferedReader (new FileReader(dataset_atpmds));
				PrintWriter wr = new PrintWriter (new File(cleaned_atpmds));
				String line = br.readLine();
				wr.append("name1, country1, name2, country2\n");
				while ((line=br.readLine())!=null) {
					String [] cols = line.split(csvSplitBy);
						if (cols.length>0)
							wr.append(clean_str(cols[10])+","+clean_str(cols[13])+","+clean_str(cols[20])+","+clean_str(cols[23])+"\n");
				}				
				br.close();
				wr.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		public String clean_str (String s) {
			s=replace(s);
			s=s.trim().replace("\"","").replace("¡","").replace("Ã©", "e").replace("’","'");	
			for (int i=0; i<s.length()-1; i++) {
				if (s.substring(i, i+1).equals(" ")) {
					if (i+1<s.length())
						if (s.substring(i+1, i+2).equals(" ")) {
							String x="";
							if (i+2<s.length())
								x=s.substring(i+2);
							s = s.substring(0, i+1)+x;
						}
				}		
			}
			return s;
		}
		
		public String clean_str_name (String s) {
			s = clean_str(s);
			s=s.replace("0", "").replace("1", "").replace("2", "").replace("3", "").replace("4", "").replace("5", "").replace("6", "").replace("7", "").replace("8", "").replace("9", "");
			s=s.trim();
			return s;
		}
		
		public String replace (String s) {
			return s.replace("Á","A")
			.replace("Â","A")
			.replace("Ã","A")
			.replace("Ä","A")
			.replace("Ç","C")
			.replace("È","E")
			.replace("É","E")
			.replace("Ê","E")
			.replace("Ë","E")
			.replace("Ì","I")
			.replace("Í","I")
			.replace("Î","I")
			.replace("Ï","I")
			.replace("Ñ","N")
			.replace("Ò","O")
			.replace("Ó","O")
			.replace("Ô","O")
			.replace("Õ","O")
			.replace("Ö","O")
			.replace("Š","S")
			.replace("Ú","U")
			.replace("Û","U")
			.replace("Ü","U")
			.replace("Ù","U")
			.replace("Ý","Y")
			.replace("Ÿ","Y")
			.replace("Ž","Z")
			.replace("á","a")
			.replace("â","a")
			.replace("ã","a")
			.replace("ä","a")
			.replace("ç","c")
			.replace("è","e")
			.replace("é","e")
			.replace("é","e")
			.replace("ê","e")
			.replace("ë","e")
			.replace("ì","i")
			.replace("í","i")
			.replace("î","i")
			.replace("ï","i")
			.replace("ñ","n")
			.replace("ò","o")
			.replace("ó","o")
			.replace("ô","o")
			.replace("õ","o")
			.replace("ö","o")
			.replace("š","s")
			.replace("ù","u")
			.replace("ú","u")
			.replace("û","u")
			.replace("ü","u")
			.replace("ý","y")
			.replace("ÿ","y")
			.replace("ž","z")
			.replace("°","'");
		}
		
		public void clean_countries () {
			try {
				BufferedReader br = new BufferedReader(new FileReader(dataset_countries));
		        PrintWriter wr = new PrintWriter(cleaned_countries);
		        String line = br.readLine();
		        wr.append("name,code_2,code_3,region\n");
		        while ((line=br.readLine())!=null) {
		        	String [] cols = line.split(",");
		        	if (cols.length>0) {
		        		String s = cols[0];
		        		if (cols.length>1)
		        			s+=","+cols[1]+","+cols[2];
		        		if (cols.length>=6)
		        			s+=","+cols[5];
		        		s+="\n";
		        		wr.append(s);
		        	}
		        }
		        br.close();
		        wr.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		
		public void clean_cities () {
			try {
				BufferedReader br = new BufferedReader(new FileReader(dataset_cities));
		        PrintWriter wr = new PrintWriter(cleaned_cities);
		        String line = br.readLine();
		        wr.append("name,country\n");
		        while ((line=br.readLine())!=null) {
		        	line=clean_str(line);
		        	String [] cols = line.split(",");
		        	if (cols[7].length()>0) {
		        		cols[1]=clean_str(cols[1]);
		        		cols[7]=clean_str(cols[7]);
		        		wr.append(cols[1]+","+cols[7]+"\n");
		        	}
		        }
		        br.close();
		        wr.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

}
