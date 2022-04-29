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

import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.Timer;
import java.util.TimerTask;

public class MapsActivity extends FragmentActivity implements OnMapReadyCallback {

    private GoogleMap mMap;
    private ActivityMapsBinding binding;
    private SupportMapFragment mapFragment;
    private FusedLocationProviderClient client;
    // private Handler handler = new Handler();
    private double[] currentLocation = new double[2];
    private LocationRequest lr;
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
//                Toast.makeText(MapsActivity.this, "Lat:"+currentLocation[0]+", Long:"+currentLocation[1],
//                            Toast.LENGTH_SHORT).show();
//                LatLng latLng = new LatLng(currentLocation[0], currentLocation[1]);
//                if (mMap != null) {
//                    mMap.addMarker(new MarkerOptions().position(latLng).title("Runner at "
//                            + "Lat:" + currentLocation[0]
//                            + ", Long:" + currentLocation[1]
//                            + ", Alt:" + location.getAltitude()));
//                    // mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(latLng, 20));
//                }
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMapsBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        // Initialise fusedLocation
        client = LocationServices.getFusedLocationProviderClient(this);
        lr = LocationRequest.create();
        lr.setInterval(1000);
        lr.setFastestInterval(1000); // update every 1 second
        lr.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
    }

    @Override
    protected void onStart() {
        super.onStart();
        if (ActivityCompat.checkSelfPermission(MapsActivity.this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            // getCurrentLocation(); // works with this on
            Toast.makeText(MapsActivity.this, "Permission to Find Location Granted", Toast.LENGTH_LONG).show();
        } else {
            ActivityCompat.requestPermissions(MapsActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 44);
            Toast.makeText(MapsActivity.this, "Permission to Find Location Denied", Toast.LENGTH_LONG).show();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        stop();
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

//    public void getCurrentLocation() {
//        // check location permission
//        if (ActivityCompat.checkSelfPermission(MapsActivity.this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
//            client.getLastLocation().addOnSuccessListener(new OnSuccessListener<Location>() {
//                @Override
//                public void onSuccess(Location location) {
//                    currentLocation[0] = location.getLatitude();
//                    currentLocation[1] = location.getLongitude();
////                    Toast.makeText(MapsActivity.this, "Lat:"+currentLocation[0]+", Long:"+currentLocation[1],
////                            Toast.LENGTH_SHORT).show();
//                }
//            });
//        } else {
//            ActivityCompat.requestPermissions(MapsActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 44);
//            Toast.makeText(MapsActivity.this, "Cannot Find Location", Toast.LENGTH_LONG).show();
//        }
//    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;
        mMap.getUiSettings().setZoomControlsEnabled(true);
        mMap.getUiSettings().setZoomGesturesEnabled(true);
        mMap.getUiSettings().setMyLocationButtonEnabled(true);
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // do nothing
        }
        mMap.setMyLocationEnabled(true);
        mMap.getUiSettings().setCompassEnabled(true);
        mMap.setMapType(GoogleMap.MAP_TYPE_TERRAIN);
        getCurrentLocation();
        // testNotification();
//        handler.postDelayed(new Runnable() {
//            @Override
//            public void run() {
//                LatLng latLng = new LatLng(currentLocation[0], currentLocation[1]);
//                mMap.addMarker(new MarkerOptions().position(latLng).title("Runner"));
//                mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(latLng, 18));
//                Toast.makeText(MapsActivity.this, "Lat:" + currentLocation[0] + ", Long:" + currentLocation[1],
//                        Toast.LENGTH_SHORT).show();
//                Log.d("myTag", "Lat:" + currentLocation[0] + ", Long:" + currentLocation[1]);
//                getCurrentLocation();
//                handler.postDelayed(this, 1000);
//            }
//        }, 10000);

//        getCurrentLocation();
//        handler.postDelayed(new Runnable() {
//            @Override
//            public void run() {
//                getCurrentLocation();
//                showPosition();
//                // handler.postDelayed(this, 1000);
//            }
//        }, 1000);
//
//        getCurrentLocation();
//        handler.postDelayed(new Runnable() {
//            @Override
//            public void run() {
//                showPosition();
//                // handler.postDelayed(this, 1000);
//            }
//        }, 1000);

    }

//    public void showPosition() {
//        if (mMap != null) {
//            LatLng latLng = new LatLng(currentLocation[0], currentLocation[1]);
//            mMap.addMarker(new MarkerOptions().position(latLng).title("Runner"));
//            mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(latLng, 18));
//            Toast.makeText(MapsActivity.this, "showPosition", Toast.LENGTH_SHORT).show();
//        }
//    }

//    public void getShowLocation() {
//        handler.postDelayed(new Runnable() {
//            @Override
//            public void run() {
//                getCurrentLocation();
//                showPosition();
//                handler.postDelayed(this, 5000);
//            }
//        }, 0);
//    }

    private void testNotification() {
        NotificationManager notificationManager = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
        Notification notification = new Notification();
        notification.color = 0xff0000ff; // Blue color light flash
        notificationManager.notify(0, notification);
    }
}

