# Hive

- model + adapter
    - model

        ```dart
        import 'package:hive/hive.dart';

        part 'message_model_adapter.dart';

        @HiveType(typeId: 0, adapterName: "MessageModelListAdapter")
        class MessageModel {

          @HiveField(0)
          String _msgType;

          @HiveField(1)
          String _title;

          @HiveField(2)
          String _body;

          @HiveField(3)
          String _url;

          @HiveField(4)
          String _userId;

          @HiveField(5)
          String _compCd;

          @HiveField(6)
          String _compNm;

          @HiveField(7)
          String _receivedDate;

          MessageModel(
              {msgType = "0",
              title = "Default_Title_Text",
              body = "Default_Body_Text",
              url = "/",
              userId,
              compCd,
              compNm = "Default_Company_Text",
              receivedDate = "0000-00-00 00:00:00"}) {
            _msgType = msgType ?? "0";
            _title = title ?? "Default_Title_Text";
            _body = body ?? "Default_Body_Text";
            _url = url ?? "/";
            _userId = userId ?? null;
            _compCd = compCd ?? null;
            _compNm = compNm ?? "Default_Company_Text";
            _receivedDate = receivedDate ?? "0000-00-00 00:00:00";
          }

          get msgType => _msgType;

          get title => _title;

          get body => _body;

          get url => _url;

          get userId => _userId;

          get compCd => _compCd;

          get compNm => _compNm;

          get receivedDate => _receivedDate;

          set msgType(msgType) {
            this._msgType = msgType;
          }

          set title(title) {
            this._title = title;
          }

          set body(body) {
            this._body = body;
          }

          set url(url) {
            this._url = url;
          }

          set userId(userId) {
            this._userId = userId;
          }

          set compCd(compCd) {
            this._compCd = compCd;
          }

          set compNm(compNm) {
            this._compNm = compNm;
          }

          set receivedDate(receivedDate) {
            this._receivedDate = receivedDate;
          }

          toMap() {
            return {
              "msgType": this._msgType,
              "title": this._title,
              "body": this._body,
              "url": this._url,
              "userId": this._userId,
              "compCd": this._compCd,
              "compNm": this._compNm,
              "receivedDate": this._receivedDate
            };
          }

          toString() {
            return toMap().toString();
          }
        }
        ```

    - adapter

        ```dart
        part of 'message_model.dart';

        class MessageModelListAdapter extends TypeAdapter<MessageModel>{

          @override
          final typeId = 0;

          @override
          MessageModel read(BinaryReader reader) {
            // TODO: implement read

            var numOfFields = reader.readByte();
            var fields = <int, dynamic>{
              for(int i =0;i<numOfFields; i++) reader.readByte() :reader.read(),
            };

            return MessageModel(
                msgType: fields[0],
                title: fields[1],
                body: fields[2],
                url: fields[3],
                userId: fields[4],
                compCd: fields[5],
                compNm: fields[6],
                receivedDate: fields[7]);
          }

          @override
          void write(BinaryWriter writer, MessageModel obj) {
            writer
              ..writeByte(8)
              ..writeByte(0)
              ..write(obj.msgType)
              ..writeByte(1)
              ..write(obj.title)
              ..writeByte(2)
              ..write(obj.body)
              ..writeByte(3)
              ..write(obj.url)
              ..writeByte(4)
              ..write(obj.userId)
              ..writeByte(5)
              ..write(obj.compCd)
              ..writeByte(6)
              ..write(obj.compNm)
              ..writeByte(7)
              ..write(obj.receivedDate);
          }

        }
        ```

    - usage

        Hive.initFlutter()이후 진행 필요

        ```dart
        Future get getBox async {
            print("하이브 : $isInited");
            if(!isInited) {
              Hive.registerAdapter(MessageModelListAdapter());
              this.isInited=true;
              print("하이브 돌아요");
            }
              return await Hive.openBox("Notifications");
          }
        ```
