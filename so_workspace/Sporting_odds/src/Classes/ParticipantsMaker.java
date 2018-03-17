package Classes;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.HashMap;
import java.lang.Exception;

public class ParticipantsMaker extends Maker{
	
	private String p_fd;
	private String p_esdb;
	private String p_football;
	private String p_nat;
	private String p_tennis_1;
	private String p_tennis;
    
	public ParticipantsMaker () {
		p_nat = etl_path + "participants_nationalities.csv";
		p_fd = etl_path + "participants_fd.csv";
		p_esdb = etl_path + "created/participants_esdb.csv";
		same_football = etl_path + "participants_same_football.csv";
		same_tennis = etl_path + "participants_same_tennis.csv";
		p_football = etl_path + "participants_football.csv";
		p_tennis_1 = etl_path + "participants_tennis_1.csv";
		p_tennis = etl_path + "participants_tennis.csv";
	    
	    make_p_fd();
	    System.out.println("Participants of Football-data maken");
	    
	    String [] writes_f = {"21", "21", "11", "20","22","_esdb"}; 
	    String [] write1_f = {"11", "_", "11", "_", "10", "_fd"};
	    String [] write2_f = {"11", "11", "_", "10", "12", "_esdb"};
	    create_map(pf_syn_map, pf_syn_file);
	    create_map(pf_syn_team_map, pf_syn_team_file);
	    integrate(p_fd, 1, p_esdb, 1, p_football, "name,name_esdb_, name_fd, team_api_id,country_id,dataset\n", same_football, writes_f, write1_f, write2_f, "p_football");
	    System.out.println("\tParticipants football integrated");
	    
	    writes_f=null;
	    write1_f=null;
	    HashMap <String, String> map = new HashMap <String, String>();
	    make_p_tennis_dataset(map, cleaned_td, p_tennis_1);
	    System.out.println("\tParticipants of Tennis-data maken");
	    make_p_tennis_dataset(map, cleaned_atpmt, p_tennis_1);
	    System.out.println("\tParticipants of ATP Men's Tour maken");
	    
	    make_nationalities();
	    System.out.println("\tTennis players' nationalites maken");
	    
	    String [] writes_t = {"10","21"};
	    String [] write1_t = {"10"};
	    integrate(p_tennis_1, 0, p_nat, 0, p_tennis, "name,nationality\n", same_tennis, writes_t, write1_t, null, "p_tennis");
	    System.out.println("\tParticipants tennis integrated");
	}  
			
	


	private void create_map(HashMap<String, String> map, String file) {
		try {
			BufferedReader br = new BufferedReader(new FileReader(file));
			String line = br.readLine();
			while ((line = br.readLine())!=null) {
				String [] cols = line.split(csvSplitBy);
				map.put(cols[0], cols[1]);
			}
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}




	public void make_p_fd () {
	    try {
	    	HashMap<String, String> map = new HashMap<String, String>();
	        BufferedReader br1 = new BufferedReader(new FileReader(cleaned_fd));
	        PrintWriter wr = new PrintWriter(new File(p_fd));
	        wr.append("div,name\n");
	        String line = "";
	        line = br1.readLine();
	        while ((line = br1.readLine()) != null) {
	            String[] cols = line.split(csvSplitBy);
	            if (cols.length>0) {
	            	putLine_fd(map, wr, cols[1],cols[3]);
	            	putLine_fd(map, wr, cols[1],cols[4]);
	            }
	        }
	        br1.close();
	        wr.close();
	
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
	public void make_p_tennis_dataset (HashMap<String, String> map, String dataset, String file_participants) {		
		try {
			BufferedReader br1 = new BufferedReader(new FileReader(dataset));
			PrintWriter wr = new PrintWriter(new FileOutputStream(new File(file_participants), true)); 
			wr.append("name\n");
			String line = "";
			line = br1.readLine();
			while ((line=br1.readLine())!=null) {
				String [] cols = line.split(csvSplitBy);
				if (cols.length>0) {
					putLine_tennis(map, wr, cols[7]);
					putLine_tennis(map, wr, cols[8]);
				}
			}
			br1.close();
			wr.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void putLine_fd (HashMap<String, String> map, PrintWriter wr, String div, String team) {
		if (!map.containsKey(team)) {
			map.put(team, "");
			try {
				wr.append(div+","+team+"\n");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	private void putLine_tennis (HashMap<String, String> map, PrintWriter wr, String player) {
		try {
			if (!map.containsKey(player)) {
				map.put(player, "");
				wr.append(player+"\n");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void make_nationalities () {
		try {
			HashMap<String, String> map = new HashMap<String, String>();
	        BufferedReader br1 = new BufferedReader(new FileReader(cleaned_atpmds));
	        PrintWriter wr = new PrintWriter(new File(p_nat));
	        wr.append("name,nationality\n");
	        String line = br1.readLine();
	        while ((line=br1.readLine())!=null) {
	        	String cols [] = line.split(csvSplitBy);
	        	if (cols.length>0) {
	        		putLine_nat(map, wr, cols[0], cols[1]);
	        		putLine_nat(map, wr, cols[2], cols[3]);
	        	}
	        }
	        br1.close();
	        wr.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void putLine_nat(HashMap<String, String> map, PrintWriter wr, String name, String nationality) {
		try {
			if(!map.containsKey(name)) {
				wr.append(name+","+nationality+"\n");
				map.put(name, "");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
