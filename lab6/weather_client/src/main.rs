use rxrust::prelude::*;

use futures_util::{future, stream, StreamExt, TryStreamExt};
use serde::Deserialize;
use tokio::io::AsyncReadExt;
use tokio_tungstenite::{connect_async, tungstenite::protocol::Message};

#[derive(Deserialize, Clone, Debug)]
struct WeatherData {
    temp: f32,
    humidity: f32,
    unit: Unit,
}

#[derive(Deserialize, Clone, Debug)]
enum Unit {
    Fahrenheit,
    Celcium,
}

#[tokio::main]
async fn main() {
    let connect_addr = "ws://127.0.0.1:9002";
    let url = url::Url::parse(&connect_addr).unwrap();
    let (ws_stream, _) = connect_async(url).await.expect("Failed to connect");
    println!("WebSocket handshake has been successfully completed");

    let (_, read) = ws_stream.split();
    {
        read.skip(3)
            .take(20)
            .map_err(|e| println!("Message error: {}", e))
            .and_then(|msg| {
                future::ok(
                    bincode::deserialize::<WeatherData>(&msg.into_data())
                        .map_err(|e| {
                            println!("Failed to deserialize weather data from message: {}", e)
                        })
                        .unwrap(),
                )
            })
            .map(|result| result.unwrap())
            .filter(|w| future::ready(w.temp >= 0.0))
            .flat_map(|w| {
                stream::iter(vec![
                    w.to_owned(),
                    WeatherData {
                        temp: (w.temp * 9.0 / 5.0 + 32.0),
                        humidity: w.humidity.to_owned(),
                        unit: Unit::Fahrenheit,
                    },
                ])
            })
            .chunks(2)
            .for_each(|messages| async {
                for weather in messages {
                    println!("Weather Data: {:?}", weather);
                }
                println!("\n");
            })
    }
    .await;
}
