# ================================================
# FIX: Point OpenSSL to correct config file
# ================================================
$env:OPENSSL_CONF = "C:\Program Files\OpenSSL-Win64\bin\openssl.cfg"  # SET PATH

# ================================================
# Certificate Variables (edit as needed)
# ================================================
$CertHost   = "www.iam7hills.com"   # Domain name
$CERT_DAYS  = 365
$KEY_FILE   = "tls.key"
$CERT_FILE  = "tls.crt"
$PFX_FILE   = "tls.pfx"
$PFX_PASS   = "ChangeMe123!"         # Choose a strong password
$ROOT_CER   = "rootCA.cer"

# ================================================
# Generate Self-Signed Certificate with SAN
# ================================================
# Full subject details are provided inline for non-interactive execution
openssl req -x509 -nodes -days $CERT_DAYS -newkey rsa:2048 `
  -keyout $KEY_FILE -out $CERT_FILE `
  -subj "/C=US/ST=California/L=SanFrancisco/O=Iam7Hills Inc/CN=$CertHost" `
  -addext "subjectAltName = DNS:$CertHost"

# ================================================
# Create PFX for Application Gateway
# ================================================
openssl pkcs12 -export -out $PFX_FILE -inkey $KEY_FILE -in $CERT_FILE -passout pass:$PFX_PASS

# ================================================
# Generate Root CA Certificate for Backend Trust
# ================================================
openssl x509 -in $CERT_FILE -outform PEM -out $ROOT_CER

# ================================================
# Summary Output
# ================================================
Write-Host "---------------------------------------"
Write-Host "Certificate generation completed!"
Write-Host "Generated files:"
Write-Host " - $KEY_FILE       (Private Key)"
Write-Host " - $CERT_FILE      (Public Certificate)"
Write-Host " - $PFX_FILE       (PFX for App Gateway)"
Write-Host " - $ROOT_CER       (Root CA for backend trust)"
Write-Host "---------------------------------------"
