package team.itis.games.run;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class RunUserRunPlugin implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler {


    private RunUserRunPlugin(PluginRegistry.Registrar registrar) {
        RunUserRunService.registrar = registrar;
    }


    static void registerWith(PluginRegistry.Registrar registrar) {
        RunUserRunPlugin icp = new RunUserRunPlugin(registrar);
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "itis.games.run");
        channel.setMethodCallHandler(icp);
        final EventChannel streamChannel = new EventChannel(registrar.messenger(), "itis.games.run/stream");
        streamChannel.setStreamHandler(icp);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

        String method = call.method;
        switch (method) {

            case "startConnection":
                RunUserRunService.startConnection((String) call.arguments);
                result.success(true);
                break;
            case "sendConnectionData":
                RunUserRunService.sendConnectionData((String) call.arguments);
                result.success(true);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink result) {
        RunUserRunService.channel = result;
    }

    @Override
    public void onCancel(Object args) {
        RunUserRunService.channel = null;
    }
}
