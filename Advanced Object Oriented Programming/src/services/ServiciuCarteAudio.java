package services;

import models.CarteAudio;
import java.util.*;
public class ServiciuCarteAudio {
    private static ServiciuCarteAudio instance = null;
    private List<CarteAudio> lista_carti_audio;

    private ServiciuCarteAudio() {
        lista_carti_audio = new ArrayList<>();
    }

    public static ServiciuCarteAudio get_instance() {
        if(instance == null) {
            instance = new ServiciuCarteAudio();
        }
        return instance;
    }

    public void adauga_carte_audio(CarteAudio carteAudio) {
        boolean ok = false;
        for(CarteAudio c : lista_carti_audio)
            if (c.equals(carteAudio)) {
                ok = true;
                System.out.println("eroare");
                break;
            }
        if(ok == false) {
            lista_carti_audio.add(new CarteAudio(carteAudio));
            ordoneaza_carti_audio();
        }
    }
    private void ordoneaza_carti_audio() {
        Collections.sort(lista_carti_audio);
    }
    public void afiseaza_carti_audio() {
        for(CarteAudio c : lista_carti_audio)
            System.out.println(c.toString());
    }
}
