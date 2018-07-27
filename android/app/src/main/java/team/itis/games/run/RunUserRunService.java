package team.itis.games.run;

import android.Manifest;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.os.IBinder;
import android.os.Looper;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnSuccessListener;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;


public class RunUserRunService extends Service {
    private static final String HOST = "137.117.155.208";
    private static final String PORT = "6456";
    public static EventChannel.EventSink channel = null;
    public static PluginRegistry.Registrar registrar = null;
    private static String mToken = null;
    NotificationManager nm;
    private WebSocketClient connection = null;

    public static void startConnection(String token) {
        mToken = token;
        Intent intent = new Intent(registrar.context(), RunUserRunService.class);
        intent.setAction("startConnection");
        registrar.activeContext().startService(intent);
    }

    public static void sendConnectionData(String data) {
        Intent intent = new Intent(registrar.context(), RunUserRunService.class);
        intent.setAction("sendConnectionData");
        intent.putExtra("data", data);
        registrar.activeContext().startService(intent);
    }

    void saveText() {
        getSharedPreferences("service", MODE_PRIVATE).edit().putString("token", mToken).apply();
    }

    String loadText() {
        return getSharedPreferences("service", MODE_PRIVATE).getString("token", "");
    }

    @Override
    public void onCreate() {
        super.onCreate();
        nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        LocationManager manager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

        if (connection == null)
            connectToWebSocket();

        if (manager == null) return;
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED)
            return;


        final FusedLocationProviderClient mFusedLocationClient = LocationServices.getFusedLocationProviderClient(getApplicationContext());
        final LocationRequest mLocationRequest = new LocationRequest();

        mLocationRequest.setInterval(2000);

        mLocationRequest.setFastestInterval(1000);

        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);

        mFusedLocationClient.requestLocationUpdates(mLocationRequest, new LocationCallback() {
            @Override
            public void onLocationResult(LocationResult locationResult) {
                super.onLocationResult(locationResult);
                Location location = locationResult.getLastLocation();
                Map<String, Object> map = new HashMap<>();
                map.put("longitude", location.getLongitude());
                map.put("latitude", location.getLatitude());
                map.put("accuracy", location.getAccuracy());
                send("user.geo", map);
            }
        }, Looper.myLooper());
        new Thread() {
            @Override
            public void run() {
                while (true) {
                    if (connection == null) {
                        connectToWebSocket();
                    }

                    if (ActivityCompat.checkSelfPermission(getApplicationContext(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                            ActivityCompat.checkSelfPermission(getApplicationContext(), Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                        return;
                    }
                    mFusedLocationClient.getLastLocation().addOnSuccessListener(new OnSuccessListener<Location>() {
                        @Override
                        public void onSuccess(Location location) {
                            if (location != null) {

                                Map<String, Object> map = new HashMap<>();
                                map.put("longitude", location.getLongitude());
                                map.put("latitude", location.getLatitude());
                                map.put("accuracy", location.getAccuracy());
                                send("user.geo", map);
                            } else {

                            }
                        }
                    });
                    try {
                        Thread.sleep(2000);
                    } catch (InterruptedException ignored) {
                    }
                }
            }
        }.start();

    }

    void sendNotif() {
        Notification.Builder builder =
                new Notification.Builder(this)
                        .setSmallIcon(R.mipmap.ic_launcher)
                        .setContentTitle("Title")
                        .setContentText("Notification text");

        Notification notification = builder.build();

        // отправляем
        nm.notify(1, notification);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    void connectToWebSocket() {
        if (mToken != null)
            saveText();

        if (connection != null) {
            try {
                connection.closeBlocking();
            } catch (InterruptedException ignored) {
            }
        }
        URI uri;
        try {
            uri = new URI("ws://" + HOST + ":" + PORT);
        } catch (URISyntaxException e) {
            e.printStackTrace();
            return;
        }

        connection = new WebSocketClient(uri) {
            @Override
            public void onOpen(ServerHandshake serverHandshake) {

            }

            @Override
            public void onMessage(String s) {
                if (channel != null) channel.success("wmsg" + s);
                try {
                    JSONObject o = new JSONObject(s);
                    String type = o.getString("type");
                    System.out.println("IN: " + type);
                    Object params = o.get("params");
                    switch (type) {
                        case "token":
                            mToken = mToken != null ? mToken : loadText();
                            System.out.println(mToken);
                            send("\"" + mToken + "\"");
                            break;
                    }
                } catch (JSONException ignored) {
                }
            }

            @Override
            public void onClose(int i, String s, boolean b) {
                if (channel != null) channel.success("wcls");
                connection = null;
            }

            @Override
            public void onError(Exception e) {
                if (channel != null) channel.success("werr" + e.getMessage());
            }
        };
        connection.connect();
    }

    private void send(Map<String, Object> o) {
        if (connection == null || !connection.isOpen()) return;
        connection.send(new JSONObject(o).toString());
    }

    void send(String type, Map<String, Object> params) {
        Map<String, Object> o = new HashMap<>();
        o.put("type", type);
        o.put("params", params);
        System.out.println(o);
        send(o);
    }

    public int onStartCommand(Intent intent, int flags, int startId) {
        final String action = intent.getAction();
        if (action != null)
            switch (action) {
                case "startConnection":

                    break;
                case "sendConnectionData":
                    if (connection != null && connection.isOpen())
                        connection.send(intent.getStringExtra("data"));
                    break;
            }
        return super.onStartCommand(intent, flags, startId);
    }

    public void onDestroy() {
        super.onDestroy();
        if (connection != null)
            connection.close();
    }


}