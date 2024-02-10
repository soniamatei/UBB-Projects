using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace lab4
{
    public class Parser : Socket
    {
        public int Id { get; }

        public string BaseUrl { get; }

        public string UrlPath { get; }

        private IPEndPoint EndPoint { get; }

        private StringBuilder ResponseContent { get; } = new StringBuilder();

        private const int DefaultHttpPort = 80;
        private const int BufferSize = 1024;
        private int _contentLenght = -1;

        public static Parser Create(string url, int id)
        {
            var index = url.IndexOf('/');
            var baseUrl = url.Substring(0, index);
            var urlPath = url.Substring(index);

            var ipHostInformation = Dns.GetHostEntry(baseUrl);
            var ipAddress = ipHostInformation.AddressList[0];

            return new Parser(baseUrl, urlPath, ipAddress, id);
        }

        private Parser(string baseUrl, string urlPath, IPAddress ipAddress, int id):
            base(ipAddress.AddressFamily, SocketType.Stream, ProtocolType.Tcp)
        {
            Id = id;
            BaseUrl = baseUrl;
            UrlPath = urlPath;
            EndPoint = new IPEndPoint(ipAddress, DefaultHttpPort);
        }

        public void BeginConnect(Action<Parser> onConnected)
        {
            BeginConnect(EndPoint, asyncResult => {
                EndConnect(asyncResult);
                onConnected(this);
            }, null);
        }

        public void BeginSend(Action<Parser, int> onSent)
        {
            var stringToSend = $"GET {UrlPath} HTTP/1.1\r\n" +
                $"Host: {BaseUrl}\r\n" +
                "Content-Length: 0\r\n\r\n";
            var encodedString = Encoding.ASCII.GetBytes(stringToSend);

            BeginSend(encodedString, 0, encodedString.Length, SocketFlags.None, asyncResult => {
                var numberOfSentBytes = EndSend(asyncResult);
                onSent(this, numberOfSentBytes);
            }, null);
        }

        public void BeginReceive(Action<Parser> onReceived)
        {
            var buffer = new byte[BufferSize];
            ResponseContent.Clear();

            BeginReceive(buffer, 0, BufferSize, SocketFlags.None, asyncResult =>
                HandleReceiveResult(asyncResult, buffer, onReceived), null);
        }

        public Task BeginConnectAsync() => Task.Run(() =>
        {
            var taskCompletion = new TaskCompletionSource<object>();

            BeginConnect(_ => { taskCompletion.TrySetResult(null);});

            return taskCompletion.Task;
        });

        public Task<int> BeginSendAsync() => Task.Run(() =>
        {
            var taskCompletion = new TaskCompletionSource<int>();

            BeginSend((_, numberOfSentBytes) =>
                taskCompletion.TrySetResult(numberOfSentBytes));

            return taskCompletion.Task;
        });

        public Task BeginReceiveAsync() => Task.Run(() =>
        {
            var taskCompletion = new TaskCompletionSource<object>();

            BeginReceive(_ => taskCompletion.TrySetResult(null));

            return taskCompletion.Task;
        });

        public void ShutdownAndClose()
        {
            Shutdown(SocketShutdown.Both);
            Close();
        }

        public int GetResponseContent => _contentLenght;
        
        private void HandleReceiveResult(
            IAsyncResult asyncResult,
            byte[] buffer,
            Action<Parser> onReceived)
        {
            var numberOfReadBytes = EndReceive(asyncResult);
            ResponseContent.Append(Encoding.ASCII.GetString(buffer, 0, numberOfReadBytes));
            var headerEndIndex = ResponseContent.ToString().IndexOf("\r\n\r\n", StringComparison.OrdinalIgnoreCase);
            if (headerEndIndex < 0)
            {
                BeginReceive(buffer, 0, BufferSize, SocketFlags.None, asyncResult2 =>
                    HandleReceiveResult(asyncResult2, buffer, onReceived), null);
                return;
            }

            var headers = ResponseContent.ToString().Substring(0, headerEndIndex)
            .Split(new string[] { "\r\n" }, StringSplitOptions.None);
            foreach (var header in headers)
            {
                if (header.StartsWith("Content-Length:"))
                {
                    var parts = header.Split(':');
                    if (parts.Length == 2 && int.TryParse(parts[1].Trim(), out _contentLenght))
                    {
                        break; 
                    }
                }
            }
            onReceived(this);
        }
    }
}