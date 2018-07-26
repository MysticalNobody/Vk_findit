package team.itis.games.run;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        RunUserRunPlugin.registerWith(this.registrarFor(RunUserRunPlugin.class.getName()));
        GeneratedPluginRegistrant.registerWith(this);
    }
}
