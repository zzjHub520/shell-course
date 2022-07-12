package com.example.ftptest1;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.tuple.Pair;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.IOException;
@Slf4j
@SpringBootTest
class FtpTest1ApplicationTests {

    @Test
    void contextLoads() {
    }

    @Test
    public void upload() throws IOException {
        ApacheFtpClient apacheFtpClient = new ApacheFtpClient("192.168.0.151", 21, "Alian", "Alian@1223");
        Pair<Boolean, String> pair = apacheFtpClient.uploadFile("apacheFTP", "C:\\myFile\\CSDN\\result.png", "GBK");
        log.info("上传返回结果：{}", pair);
        apacheFtpClient.close();
    }

    @Test
    public void download() throws IOException {
        ApacheFtpClient apacheFtpClient = new ApacheFtpClient("192.168.0.151", 21, "Alian", "Alian@1223");
        Pair<Boolean, String> pair = apacheFtpClient.downloadFile("apacheFTP", "C:\\myFile\\download", "result.png");
        log.info("下载返回结果：{}", pair);
        apacheFtpClient.close();
    }


}
