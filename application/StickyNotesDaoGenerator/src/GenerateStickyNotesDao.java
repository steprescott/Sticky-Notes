import de.greenrobot.daogenerator.DaoGenerator;
import de.greenrobot.daogenerator.Entity;
import de.greenrobot.daogenerator.Property.PropertyBuilder;
import de.greenrobot.daogenerator.Schema;

public class GenerateStickyNotesDao
{
	public static void main(String[] args) throws Exception
	{
		Schema schema = new Schema(1, "com.aespen.stickynotes.dao");

		Entity user = schema.addEntity("User");
		user.addIdProperty();
		user.addStringProperty("firstName");
		user.addStringProperty("surname");
		user.addStringProperty("email");

		Entity note = schema.addEntity("Note");
		note.addIdProperty();
		note.addStringProperty("text");
		note.addDateProperty("created");
		note.addDoubleProperty("latitude");
		note.addDoubleProperty("longitude");
		PropertyBuilder userPropertyBuilder = note.addLongProperty("author");
		note.addToOne(user, userPropertyBuilder.getProperty());

		DaoGenerator daoGenerator = new DaoGenerator();
		daoGenerator.generateAll(schema, "../StickyNotes/src");
	}
}
