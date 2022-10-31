package repository;

import database.ConexiuneBazaDeDate;
import models.Student;

import java.sql.*;
import java.sql.Date;
import java.util.*;

public class StudentRepo {

    public void adauga_student_sql(Student stud) {
        String query = "insert into student values (null, ?, ?, ?, ?)";
        try(PreparedStatement statement = ConexiuneBazaDeDate.get_instance().prepareStatement(query)) {
            statement.setString(1, stud.getNumePersoana());
            statement.setString(2, stud.getPrenumePersoana());
            statement.setString(3, Date.valueOf(stud.getdata_inscriere()).toString());
            statement.setString(4, stud.getFacultate());
            statement.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public void update_student_sql(Student stud, String facultate) {
        String query = "update `student` set `facultate` = ? where `id_student` = ?;";
        try(PreparedStatement statement = ConexiuneBazaDeDate.get_instance().prepareStatement(query)) {
            statement.setString(1, facultate);
            statement.setInt(2, stud.getIdPersoana());
            statement.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    public void sterge_student_sql(Student stud) {
        String query = "delete from `student` where `id_student` = ?;";
        try(PreparedStatement statement = ConexiuneBazaDeDate.get_instance().prepareStatement(query)) {
            statement.setInt(1, stud.getIdPersoana());
            statement.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public Map<Integer, Student> get_studenti() {
        Map<Integer, Student> map = new HashMap<Integer, Student>();
        String query = "select * from student";
        try{
            PreparedStatement preparedStatement = ConexiuneBazaDeDate.get_instance().prepareStatement(query);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Student stud = new Student();
                Integer id_student = resultSet.getInt(1);
                stud.setIdPersoana(id_student);
                stud.setNumePersoana(resultSet.getString(2));
                stud.setPrenumePersoana(resultSet.getString(3));
                stud.setdata_inscriere(resultSet.getDate(4).toLocalDate());
                stud.setFacultate(resultSet.getString(5));
                map.put(id_student, stud);
            }
        }catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }
}