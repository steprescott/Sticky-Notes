package com.aespen.stickynotes.dao;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteStatement;

import de.greenrobot.dao.AbstractDao;
import de.greenrobot.dao.Property;
import de.greenrobot.dao.internal.DaoConfig;

import com.aespen.stickynotes.dao.user;

// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT.
/** 
 * DAO for table USER.
*/
public class userDao extends AbstractDao<user, Long> {

    public static final String TABLENAME = "USER";

    /**
     * Properties of entity user.<br/>
     * Can be used for QueryBuilder and for referencing column names.
    */
    public static class Properties {
        public final static Property Id = new Property(0, Long.class, "id", true, "_id");
        public final static Property FirstName = new Property(1, String.class, "firstName", false, "FIRST_NAME");
        public final static Property Surname = new Property(2, String.class, "surname", false, "SURNAME");
        public final static Property Email = new Property(3, String.class, "email", false, "EMAIL");
    };


    public userDao(DaoConfig config) {
        super(config);
    }
    
    public userDao(DaoConfig config, DaoSession daoSession) {
        super(config, daoSession);
    }

    /** Creates the underlying database table. */
    public static void createTable(SQLiteDatabase db, boolean ifNotExists) {
        String constraint = ifNotExists? "IF NOT EXISTS ": "";
        db.execSQL("CREATE TABLE " + constraint + "'USER' (" + //
                "'_id' INTEGER PRIMARY KEY ," + // 0: id
                "'FIRST_NAME' TEXT," + // 1: firstName
                "'SURNAME' TEXT," + // 2: surname
                "'EMAIL' TEXT);"); // 3: email
    }

    /** Drops the underlying database table. */
    public static void dropTable(SQLiteDatabase db, boolean ifExists) {
        String sql = "DROP TABLE " + (ifExists ? "IF EXISTS " : "") + "'USER'";
        db.execSQL(sql);
    }

    /** @inheritdoc */
    @Override
    protected void bindValues(SQLiteStatement stmt, user entity) {
        stmt.clearBindings();
 
        Long id = entity.getId();
        if (id != null) {
            stmt.bindLong(1, id);
        }
 
        String firstName = entity.getFirstName();
        if (firstName != null) {
            stmt.bindString(2, firstName);
        }
 
        String surname = entity.getSurname();
        if (surname != null) {
            stmt.bindString(3, surname);
        }
 
        String email = entity.getEmail();
        if (email != null) {
            stmt.bindString(4, email);
        }
    }

    /** @inheritdoc */
    @Override
    public Long readKey(Cursor cursor, int offset) {
        return cursor.isNull(offset + 0) ? null : cursor.getLong(offset + 0);
    }    

    /** @inheritdoc */
    @Override
    public user readEntity(Cursor cursor, int offset) {
        user entity = new user( //
            cursor.isNull(offset + 0) ? null : cursor.getLong(offset + 0), // id
            cursor.isNull(offset + 1) ? null : cursor.getString(offset + 1), // firstName
            cursor.isNull(offset + 2) ? null : cursor.getString(offset + 2), // surname
            cursor.isNull(offset + 3) ? null : cursor.getString(offset + 3) // email
        );
        return entity;
    }
     
    /** @inheritdoc */
    @Override
    public void readEntity(Cursor cursor, user entity, int offset) {
        entity.setId(cursor.isNull(offset + 0) ? null : cursor.getLong(offset + 0));
        entity.setFirstName(cursor.isNull(offset + 1) ? null : cursor.getString(offset + 1));
        entity.setSurname(cursor.isNull(offset + 2) ? null : cursor.getString(offset + 2));
        entity.setEmail(cursor.isNull(offset + 3) ? null : cursor.getString(offset + 3));
     }
    
    /** @inheritdoc */
    @Override
    protected Long updateKeyAfterInsert(user entity, long rowId) {
        entity.setId(rowId);
        return rowId;
    }
    
    /** @inheritdoc */
    @Override
    public Long getKey(user entity) {
        if(entity != null) {
            return entity.getId();
        } else {
            return null;
        }
    }

    /** @inheritdoc */
    @Override    
    protected boolean isEntityUpdateable() {
        return true;
    }
    
}