package repository;

import database.ConexiuneBazaDeDate;
import models.Cititor;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class CititorRepo {

    public void adauga_cititor_sql(Cititor cit) {
        String query = "insert into cititor values (null, ?, ?, ?)";
        try(PreparedStatement statement = ConexiuneBazaDeDate.get_instance().prepareStatement(query)) {
            statement.setString(1, cit.getNumePersoana());
            statement.setString(2, cit.getPrenumePersoana());
            statement.setString(3, Date.valueOf(cit.getdata_inscriere()).toString());
            statement.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public void update_cititor_sql(Cititor cit, String nume) {
        String query = "update `cititor` set `nume` = ? where `id_cititor` = ?;";
        try(PreparedStatement statement = ConexiuneBazaDeDate.get_instance().prepareStatement(query)) {
            statement.setString(1, nume);
            statement.setInt(2, cit.getIdPersoana());
            statement.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    public void sterge_cititor_sql(Cititor cit) {
        String query = "delete from `cititor` where `id_cititor` = ?;";
        try(PreparedStatement statement = ConexiuneBazaDeDate.get_instance().prepareStatement(query)) {
            statement.setInt(1, cit.getIdPersoana());
            statement.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public Map<Integer, Cititor> get_cititori() {
        Map<Integer, Cititor> map = new HashMap<Integer, Cititor>();
        String query = "select * from cititor";
        try{
            PreparedStatement preparedStatement = ConexiuneBazaDeDate.get_instance().prepareStatement(query);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Cititor cit = new Cititor();
                Integer id_cititor = resultSet.getInt(1);
                cit.setIdPersoana(id_cititor);
                cit.setNumePersoana(resultSet.getString(2));
                cit.setPrenumePersoana(resultSet.getString(3));
                cit.setdata_inscriere(resultSet.getDate(4).toLocalDate());
                map.put(id_cititor, cit);
            }
        }catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }
}