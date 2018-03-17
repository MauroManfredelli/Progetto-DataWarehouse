package Make;
import Classes.*;

public class Make {

	public static void main(String[] args) {
		System.out.println("...Making competitions...");
		new CompetitionsMaker();
		System.out.println("Competitions maken");
		System.out.println("\n...Making participants...");
		new ParticipantsMaker();
		System.out.println("Participants maken");
	}

}
