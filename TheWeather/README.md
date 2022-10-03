# The Weather

**Note for first install:**

Create (or add to) Info.plist file to add the next properties: to access your machine from inside a container, use the host: `host.docker.internal` (instead of localhost)

```
OpenWeatherMapToken: your-openweathermap-api-token
```

**Considerations:**

- A countries select has been added. The zip-code search was returning too random results, mostly related to the USA.