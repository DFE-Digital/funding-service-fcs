namespace UnitTests.Common
{
    using System;
    using CoreWCF;

    public static class ErrorAbsorbingExecutor
    {
        public static void XrmExecute(Action executeStatement)
        {
            try
            {
                executeStatement();
            }
            catch (FaultException fe)
            {
                if (!fe.Message.Contains("Does Not Exist") && !fe.Message.Contains("No object matched the query"))
                {
                    throw;
                }
                else
                {
                    // crm is awful, nothing to worry about
                }
            }
        }
    }
}
