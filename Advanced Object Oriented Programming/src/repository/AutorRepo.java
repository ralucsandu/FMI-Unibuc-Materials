package repository;

import database.ConexiuneBazaDeDate;
import models.Autor;

import java.util.*;
import java.sql.*;

public class AutorRepo {

    public void adauga_autor_sql(Autor autor) {
        String query = "insert into autor values (null, ?, ?)";
        try(PreparedStatement statement = ConexiuneBazaDeDate.get_instance().prepareStatement(query)) {
            statement.setString(1, autor.getNumePersoana());
            statement.setString(2, autor.getPrenumePersoana());
            statement.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public void sterge_autor_sql(Autor autor) {
        String query = "delete from `autor` where `id_autor` = ?;";
        try(PreparedStatement statement = ConexiuneBazaDeDate.get_instance().prepareStatement(query)) {
            statement.setInt(1, autor.getIdPersoana());
            statement.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public Map<Integer, Autor> get_toti_autorii() {
        Map<Integer, Autor> map = new HashMap<Integer, Autor>();
        String query = "select * from autor";
        try{
            PreparedStatement preparedStatement = ConexiuneBazaDeDate.get_instance().prepareStatement(query);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Autor autor = new Autor();
                Integer id_autor = resultSet.getInt(1);
                autor.setIdPersoana(id_autor);
                autor.setNumePersoana(resultSet.getString(2));
                autor.setPrenumePersoana(resultSet.getString(3));
                map.put(id_autor, autor);
            }
        }catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }
}