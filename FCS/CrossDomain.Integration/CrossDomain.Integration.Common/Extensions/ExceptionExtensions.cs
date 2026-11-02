using System;
using System.Collections.Generic;

namespace SFA.FCT.CrossDomain.Integration.Common.Extensions
{
    public static class ExceptionExtensions
    {
        public static IEnumerable<Exception> GetAllExceptions(this Exception ex)
        {
            Exception currentEx = ex;
            yield return currentEx;
            while (currentEx.InnerException != null)
            {
                currentEx = currentEx.InnerException;
                yield return currentEx;
            }
        }
    }
}
