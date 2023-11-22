use futures_util::{SinkExt, StreamExt};
use rand::Rng;
use serde::Serialize;
use std::{net::SocketAddr, time::Duration};
use tokio::net::{TcpListener, TcpStream};
use tokio_tungstenite::{
    accept_async,
    tungstenite::{Error, Message, Result},
};

#[derive(Serialize, Debug)]
struct WeatherData {
    temp: f32,
    humidity: f32,
    unit: Unit,
}

#[derive(Serialize, Debug)]
enum Unit {
    Fahrenheit,
    Celcium,
}

#[tokio::main]
async fn main() {
    let addr = "127.0.0.1:9002";
    let listener = TcpListener::bind(&addr).await.expect("Can't listen");
    println!("Listening on: {}", addr);

    while let Ok((stream, _)) = listener.accept().await {
        let peer = stream
            .peer_addr()
            .expect("connected streams should have a peer address");
        println!("Peer address: {}", peer);

        tokio::spawn(accept_connection(peer, stream));
    }
}

async fn accept_connection(peer: SocketAddr, stream: TcpStream) {
    if let Err(e) = handle_connection(peer, stream).await {
        match e {
            Error::ConnectionClosed | Error::Protocol(_) | Error::Utf8 => (),
            err => println!("Error processing connection: {}", err),
        }
    }
}

async fn handle_connection(peer: SocketAddr, stream: TcpStream) -> Result<()> {
    let ws_stream = accept_async(stream).await.expect("Failed to accept");
    println!("New WebSocket connection: {}", peer);
    let (mut ws_sender, _) = ws_stream.split();
    let mut interval = tokio::time::interval(Duration::from_millis(1000));

    loop {
        tokio::select! {
            _ = interval.tick() => {
                let weather = generate_weather_data().await;
                println!("Weather Data: {:?}", &weather);

                let weather_data = bincode::serialize(&weather)
                    .expect("Failed to serialize weather data!");
                
                ws_sender.send(Message::Binary(weather_data)).await?;
            }
        }
    }
}

async fn generate_weather_data() -> WeatherData {
    // Replace this with your actual weather data generation logic
    let temp = rand::thread_rng().gen_range(-20.0..40.0);
    let humidity = rand::thread_rng().gen_range(0.0..100.0);

    WeatherData {
        temp,
        humidity,
        unit: Unit::Celcium,
    }
}
