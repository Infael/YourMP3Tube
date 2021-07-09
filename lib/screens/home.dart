import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '/widgets/text_input.dart';
import '/utilities/youtube_util.dart';
import '/utilities/download_status.dart';
import '/models/video_data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  String url = "";
  YoutubeUtil youtubeHandler = YoutubeUtil();
  VideoData videoData = VideoData();
  DownloadStatus downloadStatus = DownloadStatus.ready;

  double _dialogeWindowWidth = 0;
  String _downloadDirectory = '';

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    videoData.url = "assets/images/logo.png";
    super.initState();
  }

  void setUrl(String newUrl) async {
    url = newUrl;
    if (await youtubeHandler.loadVideo(url)) {
      setThumbnail();
      setVideoData();
      resetDownloadStatus();
    }
  }

  void setThumbnail() {
    setState(() {
      videoData.url = youtubeHandler.getVideoThumbnailUrl();
    });
  }

  void setVideoData() {
    setState(() {
      videoData.title = youtubeHandler.getVideoTitle();
      videoData.author = youtubeHandler.getVideoAuthor();
    });
  }

  void resetDownloadStatus() {
    setState(() {
      downloadStatus = DownloadStatus.ready;
    });
  }

  void startDownloading() {
    setState(() {
      downloadStatus = DownloadStatus.downloading;
      _animationController.repeat();
    });
  }

  void changeDownloading(bool status) {
    setState(() {
      _animationController.reset();
      if (status)
        downloadStatus = DownloadStatus.success;
      else
        downloadStatus = DownloadStatus.fail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _helpHeight = 40;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Container(
        width: _width,
        height: _helpHeight,
        child: Stack(
          children: [
            Positioned(
              left: 30.0,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.grey[700],
                ),
                width: _dialogeWindowWidth,
                height: _helpHeight,
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 5),
                  child: Center(
                    child: Text(
                      _downloadDirectory,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () async {
                if (_downloadDirectory == '') {
                  _downloadDirectory = await youtubeHandler.getSaveLocation();
                }
                setState(() {
                  if (_dialogeWindowWidth == 0)
                    _dialogeWindowWidth = _width - 75;
                  else
                    _dialogeWindowWidth = 0;
                });
              },
              child: Text(
                "?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 30,
          left: 36,
          right: 36,
          bottom: 20,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 232,
                decoration: BoxDecoration(
                  // border: Border.all(),
                  borderRadius: BorderRadius.circular(30.0),
                  image: youtubeHandler.videoLoaded
                      ? DecorationImage(image: NetworkImage(videoData.url))
                      : DecorationImage(image: AssetImage(videoData.url)),
                ),
              ),
              Visibility(
                visible: youtubeHandler.videoLoaded ? true : false,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Text(
                          videoData.author + " -",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            videoData.title,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: Colors.red.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text("Inser URL:",
                      style: TextStyle(color: Theme.of(context).accentColor)),
                ),
              ),
              TextInput(onTap: setUrl),
              SizedBox(height: 50),
              Visibility(
                visible: youtubeHandler.videoLoaded ? true : false,
                child: ElevatedButton(
                  onPressed: () async {
                    if (downloadStatus != DownloadStatus.downloading) {
                      await Permission.storage.request();
                      startDownloading();
                      final bool success = await youtubeHandler.downloadMP3();
                      changeDownloading(success);
                    }
                  },
                  child: (downloadStatus == DownloadStatus.downloading)
                      ? RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0)
                              .animate(_animationController),
                          child: Icon(Icons.hourglass_empty, size: 60))
                      : (downloadStatus == DownloadStatus.ready)
                          ? Icon(Icons.download, size: 60)
                          : (downloadStatus == DownloadStatus.success)
                              ? Icon(Icons.done, size: 60)
                              : Icon(Icons.close, size: 60),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).accentColor,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
