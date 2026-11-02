namespace Operations.Web.Services
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;

    public interface ICheckerFactory
    {
        Dictionary<string, Func<Task<AvailabilityCheckResult>>> GetAvailabilityCheckerDictionary();
    }
}