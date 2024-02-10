using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace lab4
{
    public class Taskk
    {
        private List<string> Urls { get; }
        private string ParserType => "Task";

        public Taskk(List<string> urls) 
        {
            Urls = urls;
            Run();
        }

        private void Run()
        {
            var count = 0;
            var function = (Func<int, string, Task>)((index, url) => Task.Run(() => Start(Parser.Create(url, index))));
            var tasks = Urls.Select(url => function(count++, url)).ToList();
            Task.WhenAll(tasks).Wait();
        }

        private Task Start(Parser socket)
        {
            socket.BeginConnectAsync().Wait();
            Console.WriteLine($"{ParserType}-{socket.Id}: Socket connected to {socket.BaseUrl} ({socket.UrlPath})");

            var sendTask = socket.BeginSendAsync();
            sendTask.Wait();
            var numberOfSentBytes = sendTask.Result;
            Console.WriteLine($"{ParserType}-{socket.Id}: Sent {numberOfSentBytes} bytes to server.");

            socket.BeginReceiveAsync().Wait();
            Console.WriteLine($"{ParserType}-{socket.Id}: {socket.GetResponseContent}");

            socket.ShutdownAndClose();
            return Task.CompletedTask;
        }
    }
}