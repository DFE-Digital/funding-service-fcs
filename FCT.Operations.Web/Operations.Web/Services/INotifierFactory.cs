namespace Operations.Web.Services
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;

    public interface INotifierFactory
    {
        IReadOnlyCollection<Func<Task<Notification>>> GetNotifiers();
    }
}