# The Weather

**Note for first install:**

Create (or add to) Info.plist file to add the next properties: to access your machine from inside a container, use the host: `host.docker.internal` (instead of localhost)

```
OpenWeatherMapToken: your-openweathermap-api-token
```

**Considerations:**

- The zip-code search was returning too random results. The only way to ensure the correct results it's add the country with the format "00000,ES".