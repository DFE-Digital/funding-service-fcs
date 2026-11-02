namespace ContractManagementService.Infrastructure
{
    using System;
    using LanguageExt;

    public static class Execute
    {
        public static Either<TEx, T> ExecuteAndCheckForException<TEx, T>(Func<T> executeCode) where TEx : Exception
        {
            try
            {
                return executeCode();
            }
            catch (TEx ex)
            {
                return ex;
            }
        }
    }
}
