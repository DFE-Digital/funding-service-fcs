
using System;
using System.Configuration;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.ServiceModel;
using System.ServiceModel.Channels;
using schemas.sfa.gov.uk.cpds.gatewayservice;

namespace OrganisationDomain.Implementation.ExternalServices.Helper
{
    public static class GatewayServiceClientFactory
    {
        public static GatewayServiceContractClient Create()
        {
            var url = ConfigurationManager.AppSettings["CPDS:EndpointUrl"];
            var thumbprint = ConfigurationManager.AppSettings["CPDS:CertThumbprint"];

            var binding = new BasicHttpBinding(BasicHttpSecurityMode.Transport)
            {
                MaxReceivedMessageSize = int.MaxValue,
                ReaderQuotas = System.Xml.XmlDictionaryReaderQuotas.Max,
                Security =
                {
                    Transport =
                    {
                        ClientCredentialType = HttpClientCredentialType.Certificate
                    }
                },
                SendTimeout = TimeSpan.FromSeconds(30),
                ReceiveTimeout = TimeSpan.FromSeconds(30)
            };

            var endpoint = new EndpointAddress(url);

            var client = new GatewayServiceContractClient(binding, endpoint);

            // ✅ Load certificate
            var cert = GetCertificateByThumbprint(thumbprint);

            client.ClientCredentials.ClientCertificate.Certificate = cert;

            return client;
        }

        private static X509Certificate2 GetCertificateByThumbprint(string thumbprint)
        {
            using var store = new X509Store(StoreName.My, StoreLocation.CurrentUser);
            store.Open(OpenFlags.ReadOnly);

            var cert = store.Certificates
                .Find(X509FindType.FindByThumbprint, thumbprint, validOnly: false)
                .OfType<X509Certificate2>()
                .FirstOrDefault();

            if (cert == null)
            {
                throw new InvalidOperationException($"Certificate not found: {thumbprint}");
            }

            return cert;
        }
    }
}
