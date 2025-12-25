# Release Application

## Android
### Cafe Bazaar
![Download Bundle Signer](https://github.com/cafebazaar/bundle-signer/releases)
```bash
java -jar bundlesigner-0.1.13.jar genbin -v --bundle WeDontPayMuch-v1.0.0.aab --bin . --v2-signing-enabled true --v3-signing-enabled false --ks upload-keystore.jks
```