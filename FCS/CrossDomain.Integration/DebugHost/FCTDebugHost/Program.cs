namespace SFA.FCT.FCTDebugHost
{
    using System;
    using System.Runtime.InteropServices;
    using System.Threading;
    using System.Threading.Tasks;

    public class Program
    {
        private static readonly CancellationTokenSource CancelOnProgramTerminationSource = new CancellationTokenSource();

        private static Task[] _busTasks = null;

        public delegate bool HandlerRoutine(CtrlTypes ctrlType);

        public enum CtrlTypes
        {
            CTRL_C_EVENT = 0,
            CTRL_BREAK_EVENT,
            CTRL_CLOSE_EVENT,
            CTRL_LOGOFF_EVENT = 5,
            CTRL_SHUTDOWN_EVENT
        }

        [DllImport("Kernel32")]
        public static extern bool SetConsoleCtrlHandler(HandlerRoutine handler, bool add);

        public static void Main(string[] args)
        {
            // use the Win32 handler to get the window close event created by clicking on the window close widget
            SetConsoleCtrlHandler(new HandlerRoutine(ConsoleCtrlCheck), true);

            // handle the control-c exit situation
            Console.CancelKeyPress += (o, e) =>
            {
                // by cancelling the cancellation token
                CancelOnProgramTerminationSource.Cancel();

                // and then cancelling this event
                e.Cancel = true;
            };

            FctEndpointRunner runner = new FctEndpointRunner();

            // and then run all of the endpoints
            _busTasks = runner.Run(CancelOnProgramTerminationSource);

            // until any of them fail
            Task.WaitAny(_busTasks);

            // and then signal all of them to exit
            CancelOnProgramTerminationSource.Cancel();

            if (!Task.WaitAll(_busTasks, 60000))
            {
                Console.WriteLine("Not all tasks accepted the cancellation signal");
            }
        }

        private static bool ConsoleCtrlCheck(CtrlTypes ctrlType)
        {
            CancelOnProgramTerminationSource.Cancel();
            if (_busTasks != null)
            {
                Task.WaitAll(_busTasks);
            }

            return true;
        }
    }
}