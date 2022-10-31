package repository;

import database.ConexiuneBazaDeDate;
import models.Categorie;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class CategorieRepo {

    public void adauga_categorie_sql(Categorie categ) {
        String query = "insert into categorie values (?, ?)";
        try(PreparedStatement statement = ConexiuneBazaDeDate.get_instance().prepareStatement(query)) {
            statement.setInt(1, categ.getIdCategorie());
            statement.setString(2, categ.getDenumire());
            statement.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public void update_categorie_sql(Categorie categ, String denumire) {
        String query = "update `categorie` set `denumire` = ? where `id_categorie` = ?;";
        try(PreparedStatement statement = ConexiuneBazaDeDate.get_instance().prepareStatement(query)) {
            statement.setString(1, denumire);
            statement.setInt(2, categ.getIdCategorie());
            statement.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public void sterge_categorie_sql(Categorie categ) {
        String query = "delete from `categorie` where `id_categorie` = ?;";
        try(PreparedStatement statement = ConexiuneBazaDeDate.get_instance().prepareStatement(query)) {
            statement.setInt(1, categ.getIdCategorie());
            statement.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public Map<Integer, Categorie> get_categs() {
        Map<Integer, Categorie> map = new HashMap<Integer, Categorie>();
        String query = "select * from categorie";
        try{
            PreparedStatement preparedStatement = ConexiuneBazaDeDate.get_instance().prepareStatement(query);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Categorie categ = new Categorie();
                Integer id_categorie = resultSet.getInt(1);
                categ.setIdCategorie(id_categorie);
                categ.setDenumire(resultSet.getString(2));
                map.put(id_categorie, categ);
            }
        }catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }
}