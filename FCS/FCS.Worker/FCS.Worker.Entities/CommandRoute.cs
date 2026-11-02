namespace SFA.FCS.Worker.Common
{
    using System;

    public class CommandRoute
    {
        public CommandRoute(string destination, Type commandType)
        {
            Destination = destination;
            CommandType = commandType;
        }

        public string Destination { get; }

        public Type CommandType { get; }
    }
}