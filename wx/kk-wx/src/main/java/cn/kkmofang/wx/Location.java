package cn.kkmofang.wx;

/**
 * Created by hailong11 on 2018/11/12.
 */

public interface Location {

    class ChooseObject {

        class Result {
            public String name;
            public String address;
            public double latitude;
            public double longitude;
        }

        interface Success {
            void invoke(Result res);
        }

        interface Fail {
            void invoke(Exception ex);
        }

        interface Complete {

        }

        public Success success;
        public Fail fail;
        public Complete complete;

    }

    void chooseLocation(ChooseObject object);

    class GetObject {

        class Result {
        }

        interface Success {
            void invoke(Result res);
        }

        interface Fail {
            void invoke(Exception ex);
        }

        interface Complete {

        }

        public Success success;
        public Fail fail;
        public Complete complete;

        public String type;
        public boolean altitude;

    }

    void getLocation(GetObject object);

}
