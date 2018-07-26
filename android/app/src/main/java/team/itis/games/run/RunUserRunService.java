package team.itis.games.run;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.support.annotation.Nullable;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;
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
    WebSocketClient connection = null;

    public static void startConnection(String token) {
        Intent intent = new Intent(registrar.context(), RunUserRunService.class);
        intent.setAction("startConnection");
        intent.putExtra("token", token);
        registrar.activity().startService(intent);
    }

    public static void stopConnection() {
        Intent intent = new Intent(registrar.context(), RunUserRunService.class);
        intent.setAction("stopConnection");
        registrar.activity().startService(intent);
    }

    public static void sendConnectionData(String data) {
        Intent intent = new Intent(registrar.context(), RunUserRunService.class);
        intent.setAction("sendConnectionData");
        intent.putExtra("data", data);
        registrar.activity().startService(intent);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    public void onCreate() {
        super.onCreate();
    }

    WebSocketClient connectToWebSocket() {
        if (connection != null && connection.isOpen())
            return connection;
        URI uri;
        try {
            uri = new URI("ws://" + HOST + ":" + PORT);
        } catch (URISyntaxException e) {
            e.printStackTrace();
            return null;
        }

        connection = new WebSocketClient(uri) {
            @Override
            public void onOpen(ServerHandshake serverHandshake) {
            }

            @Override
            public void onMessage(String s) {
                if (channel != null) channel.success("wmsg" + s);
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
        return connection;
    }

    private void send(Map<String, Object> o) {
        connection.send(new JSONObject(o).toString());
    }

    void send(String type, Map<String, Object> params) {
        Map<String, Object> o = new HashMap<>();
        o.put("type", type);
        o.put("params", params);
        send(o);
    }

    public int onStartCommand(Intent intent, int flags, int startId) {
        final String action = intent.getAction();
        if (action != null)
            switch (action) {
                case "startConnection":
                    if (connection != null && connection.isOpen())
                        connection.close();
                    connection = connectToWebSocket();
                    break;
                case "stopConnection":
                    if (connection != null && connection.isOpen())
                        connection.close();
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