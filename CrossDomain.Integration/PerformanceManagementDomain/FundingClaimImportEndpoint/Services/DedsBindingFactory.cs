namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services
{
    using System;
    using System.ServiceModel;
    internal static class DedsBindingFactory
    {
        public static BasicHttpBinding Create(string bindingName)
        {
            var binding = new BasicHttpBinding
            {
                MaxReceivedMessageSize = 1024 * 1024 * 20
            };

            switch (bindingName)
            {
                case "BasicHttpBinding_IDedsSearchService":
                case "BasicHttpBinding_IDedsSearchService1":
                    binding.Security.Mode = BasicHttpSecurityMode.None;
                    break;

                case "BasicHttpsBinding_IDedsSearchService":
                case "BasicHttpsBinding_IDedsSearchService1":
                    binding.Security.Mode = BasicHttpSecurityMode.Transport;
                    break;

                default:
                    throw new InvalidOperationException($"Unknown WCF binding: {bindingName}");
            }

            return binding;
        }
    }

}
