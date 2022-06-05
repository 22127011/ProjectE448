package com.example.pacer;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.app.ActivityCompat;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentContainerView;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.IntentSender;
import android.content.pm.PackageManager;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Toast;

import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResponse;
import com.google.android.gms.location.SettingsClient;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.example.pacer.databinding.ActivityMapsBinding;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.nio.Buffer;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Scanner;
import java.util.Timer;
import java.util.TimerTask;

public class MapsActivity extends FragmentActivity implements OnMapReadyCallback {

    private boolean started = false;
    private GoogleMap mMap;
    private ActivityMapsBinding binding;
    private SupportMapFragment mapFragment;
    private FusedLocationProviderClient client;
    private Handler handler = new Handler();
    private double[] currentLocation = new double[2];
    private LocationRequest lr;
    private FileOutputStream fos = null;
    private String[] extra,robot3,robot4;
    private int time = 0;
    private List<String> list = new ArrayList<String>();

    LocationCallback lc = new LocationCallback() {
        @Override
        public void onLocationResult(LocationResult locationResult) {
            if (locationResult == null) {
                Toast.makeText(MapsActivity.this, "No Location Found",
                        Toast.LENGTH_SHORT).show();
                return;
            }
            for (Location location : locationResult.getLocations()) {
                currentLocation[0] = location.getLatitude();
                currentLocation[1] = location.getLongitude();
                LatLng latlng = new LatLng(currentLocation[0],currentLocation[1]);
                mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(latlng,mMap.getCameraPosition().zoom));
                if (fos!=null && hasStarted()) wtf(currentLocation[0] + "," + currentLocation[1] + "\n");
            }
        }
    };

    private boolean hasStarted() {
        return started;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMapsBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        // load robot.txt
        list.add("-33.9323600,18.8727200\n" +
                "-33.9323101,18.8727421\n" +
                "-33.9322681,18.8727611\n" +
                "-33.9322254,18.8727781\n" +
                "-33.9321866,18.8728054\n" +
                "-33.9321552,18.8728265\n" +
                "-33.9321154,18.8728518\n" +
                "-33.9320823,18.8728688\n" +
                "-33.9320429,18.8728948\n" +
                "-33.9320097,18.8729107\n" +
                "-33.9319676,18.8729289\n" +
                "-33.9319268,18.8729515\n" +
                "-33.9318945,18.8729704\n" +
                "-33.9318559,18.8729982\n" +
                "-33.9318253,18.8730210\n" +
                "-33.9317937,18.8730406\n" +
                "-33.9317601,18.8730544\n" +
                "-33.9317239,18.8730865\n" +
                "-33.9316961,18.8731140\n" +
                "-33.9316643,18.8731344\n" +
                "-33.9316327,18.8731549\n" +
                "-33.9316016,18.8731767\n" +
                "-33.9315652,18.8732077\n" +
                "-33.9315370,18.8732324\n" +
                "-33.9314959,18.8732539\n" +
                "-33.9314728,18.8732707\n" +
                "-33.9314415,18.8732922\n" +
                "-33.9314107,18.8733146\n" +
                "-33.9313790,18.8733347\n" +
                "-33.9313542,18.8733478\n" +
                "-33.9313259,18.8733744\n" +
                "-33.9312956,18.8733979\n" +
                "-33.9312639,18.8734180\n" +
                "-33.9312473,18.8734263");

        extra = list.toArray(new String[0]);

        // Initialise fusedLocation
        client = LocationServices.getFusedLocationProviderClient(this);

        // Initialise location request setting
        lr = LocationRequest.create();
        lr.setInterval(1000);
        lr.setFastestInterval(1000); // update every 1 second
        lr.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
    }

    @Override
    protected void onStart() {
        super.onStart();
        if (ActivityCompat.checkSelfPermission(MapsActivity.this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(MapsActivity.this, "Permission to Find Location Granted", Toast.LENGTH_SHORT).show();
        } else {
            ActivityCompat.requestPermissions(MapsActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 44);
            Toast.makeText(MapsActivity.this, "Permission to Find Location Denied", Toast.LENGTH_LONG).show();
        }
    }

    private void wtf(String route) {
        if (time==0) Toast.makeText(MapsActivity.this, "Route data writing to route.txt", Toast.LENGTH_SHORT).show();
        time = time + 1;
        if (time==1) robot3 = extra[0].split("\n");

        try {
            fos.write(route.getBytes());
            robot4 = robot3[time-1].split(",");
            double lat = Double.parseDouble(robot4[0]); // when br.readLine()=='', program crashes
            double lng = Double.parseDouble(robot4[1]); // from string to lat long as double
            LatLng latLng = new LatLng(lat, lng);
            mMap.addMarker(new MarkerOptions().position(latLng).title("Robot"));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        try {
            fos = new FileOutputStream(new File(getApplication().getFilesDir(),"route.txt"));
        } catch (Exception e) {
            e.printStackTrace();
        }

        mMap = googleMap;
        mMap.getUiSettings().setZoomControlsEnabled(true);
        mMap.getUiSettings().setZoomGesturesEnabled(true);
        mMap.getUiSettings().setMyLocationButtonEnabled(true);
        if (ActivityCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // do nothing
        }
        mMap.setMyLocationEnabled(true);
        mMap.getUiSettings().setCompassEnabled(true);
        mMap.setMapType(GoogleMap.MAP_TYPE_TERRAIN);
        mMap.moveCamera(CameraUpdateFactory.zoomTo(20));

        getCurrentLocation();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(MapsActivity.this, "Map and files are ready", Toast.LENGTH_SHORT).show();
                started = true;
            }
        }, 5000); // 5 second delay for files and map to prepare
    }

    private void getCurrentLocation() {
        LocationSettingsRequest request = new LocationSettingsRequest.Builder().addLocationRequest(lr).build();
        SettingsClient sclient = LocationServices.getSettingsClient(this);
        Task<LocationSettingsResponse> lsrt = sclient.checkLocationSettings(request);
        lsrt.addOnSuccessListener(new OnSuccessListener<LocationSettingsResponse>() {
            @Override
            public void onSuccess(LocationSettingsResponse locationSettingsResponse) {
                start(); // start location updates
            }
        });
        lsrt.addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                if (e instanceof ResolvableApiException) {
                    ResolvableApiException apiException = (ResolvableApiException) e;
                    try {
                        apiException.startResolutionForResult(MapsActivity.this, 100);
                    } catch (IntentSender.SendIntentException sendIntentException) {
                        sendIntentException.printStackTrace();
                    }
                }
            }
        });
    }

    private void start() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // do nothing
        }
        client.requestLocationUpdates(lr, lc, Looper.getMainLooper());
    }

    private void stop() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // do nothing
        }
        client.removeLocationUpdates(lc); // start location updates
    }


    private void testNotification() {
        NotificationManager notificationManager = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
        Notification notification = new Notification();
        notification.color = 0xff0000ff; // Blue color light flash
        notificationManager.notify(0, notification);
    }

    @Override
    protected void onStop() {
        super.onStop();
        stop();

        try {
            fos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

