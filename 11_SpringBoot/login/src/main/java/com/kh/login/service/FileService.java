package com.kh.login.service;

import com.kh.login.domain.File;
import com.kh.login.repository.FileRepository;
import java.time.Duration;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.PresignedPutObjectRequest;

@Service
@Transactional(readOnly = true)
public class FileService {

    private final S3Presigner s3Presigner;
    private final FileRepository fileRepository;
    private final String bucket;

    public FileService(S3Presigner s3Presigner,
                       FileRepository fileRepository,
                       @Value("${aws.s3.bucket}") String bucket) {
        this.s3Presigner = s3Presigner;
        this.fileRepository = fileRepository;
        this.bucket = bucket;
    }

    // S3 presigned URL 발급
    public String generatePresignedUploadUrl(String fileName, String contentType) {
        PutObjectRequest objectRequest = PutObjectRequest.builder()
                .bucket(bucket)
                .key(fileName)
                .contentType(contentType)
                .build();

        PresignedPutObjectRequest presignedRequest = s3Presigner.presignPutObject(
                r -> r.putObjectRequest(objectRequest)
                        .signatureDuration(Duration.ofMinutes(5))
        );

        return presignedRequest.url().toString();
    }

    // 파일 메타데이터 저장
    @Transactional
    public File saveFileInfo(String originalName, String changeName, String contentType) {
        File files = File.builder()
                .originalName(originalName)
                .changeName(changeName)
                .contentType(contentType)
                .build();

        return fileRepository.save(files);
    }

    // 파일 목록 조회
    public List<File> getAllFiles() {
        return fileRepository.findAll();
    }

    // 파일 단건 조회
    public File getFile(Long id) {
        return fileRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("File not found with id: " + id));
    }

    // 파일 다운로드용 presigned URL 발급
    public String generatePresignedDownloadUrl(String fileName) {
        return s3Presigner.presignGetObject(r -> r.getObjectRequest(get -> get
                                .bucket(bucket)
                                .key(fileName))//경로
                        .signatureDuration(Duration.ofMinutes(5)))
                .url()
                .toString();
    }
}
