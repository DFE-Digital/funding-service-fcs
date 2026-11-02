namespace SFA.FCT.PerformanceTests
{
   using System.Configuration;
   using System.Security.Authentication;
   using System.Threading;
   using Microsoft.IdentityModel.Clients.ActiveDirectory;

   public static class AzureAuthentication1
   {
      private static readonly string AadInstance = "https://login.microsoftonline.com/{0}";
      private static readonly string Tenant = "fcsazuresfabisgov.onmicrosoft.com";
      private static readonly string ClientId = "";
      private static readonly string AppKey = "";
      private static readonly string ResourceId = "http://fcsazuresfabisgov.onmicrosoft.com/ContractManagementService";

      public static AuthenticationResult GetAuthenticationResult()
      {
         string authority = string.Format(AadInstance, Tenant);
         AuthenticationContext authContext = new AuthenticationContext(authority);
         ClientCredential clientCredential = new ClientCredential(ClientId, AppKey);

         AuthenticationResult authResult = null;
         int retryCount = 0;
         bool retry;

         do
         {
            retry = false;
            try
            {
               authResult = authContext.AcquireToken(ResourceId, clientCredential);
               return authResult;
            }
            catch (AdalException ex)
            {
               if (ex.ErrorCode == "temporarily_unavailable")
               {
                  retry = true;
                  retryCount++;
                  Thread.Sleep(3000);
               }
            }
         }
         while (retry && (retryCount < 3));

         if (authResult == null)
         {
            throw new AuthenticationException("Could not authenticate with the OAUTH2 claims provider after several attempts");
         }
         return authResult;
      }
   }
}

