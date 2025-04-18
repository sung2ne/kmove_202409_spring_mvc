package com.example.spring.authPost;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/auth-posts")
public class AuthPostController {
    
    @Autowired
    AuthPostService authPostService;

    // private final String uploadPath = "C:/upload/post"; // 파일 업로드 경로
    private final String uploadPath = "/Users/jeongps/Developments/upload/post"; // 파일 업로드 경로

    // 게시글 등록 (화면, GET)
    @GetMapping("/create")
    public String createGet() {
        return "post/create";
    }

    // 게시글 등록 (처리, POST)
    @PostMapping("/create")
    public String createPost(AuthPostDto post, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        // 세션에서 userId 가져오기
        String userId = (String) request.getSession().getAttribute("userId");
        post.setUserId(userId);

        // 파일 업로드 처리
        try {
            // 업로드 파일 정보
            MultipartFile uploadFile = post.getUploadFile();

            // 업로드 파일이 존재하는 경우
            if (uploadFile != null && !uploadFile.isEmpty()) {
                // 업로드 파일 이름
                String originalFileName = uploadFile.getOriginalFilename();

                // DB에 저장할 파일 이름
                String fileName = UUID.randomUUID().toString() + "_" + originalFileName;

                // 업로드 디렉토리가 없으면 생성
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // 파일 저장
                File destFile = new File(uploadPath + File.separator + fileName);
                uploadFile.transferTo(destFile);

                // 파일 정보 설정
                post.setFileName(fileName);
                post.setOriginalFileName(originalFileName);
            }

            // 게시글 등록
            boolean created = authPostService.create(post);

            // 게시글 등록 성공
            if (created) {
                redirectAttributes.addFlashAttribute("successMessage", "게시글이 등록되었습니다.");
                return "redirect:/posts/";
            }

            // 게시글 등록 실패
            redirectAttributes.addFlashAttribute("errorMessage", "게시글 등록에 실패했습니다.");
            return "redirect:/posts/create";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "파일 업로드에 실패했습니다.");
            return "redirect:/posts/create";
        }        
    }

    // 게시글 목록 (화면, GET)
    @GetMapping("")
    public String listGet(
        @RequestParam(value = "page", defaultValue = "1") int currentPage, 
        @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
        @RequestParam(value = "searchType", required = false) String searchType,
        Model model
    ) {
        int listCountPerPage = 10;  // 한 페이지에서 불러올 게시글 수
        int pageCountPerPage = 5;   // 한 페이지에서 보여질 페이지 수
        Map<String, Object> result = authPostService.list(currentPage, listCountPerPage, pageCountPerPage, searchType, searchKeyword);
        model.addAttribute("posts", result.get("posts"));
        model.addAttribute("pagination", result.get("pagination"));
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("searchType", searchType);
        return "post/list";
    }

    // 게시글 보기 (화면, GET)
    @GetMapping("/{id}")
    public String readGet(@PathVariable("id") int id, Model model) {
        AuthPostDto post = authPostService.read(id);
        model.addAttribute("post", post);
        return "post/read";
    }

    // 게시글 수정 (화면, GET)
    @GetMapping("/{id}/update")
    public String updateGet(@PathVariable("id") int id, Model model) {
        AuthPostDto post = authPostService.read(id);
        model.addAttribute("post", post);
        return "post/update";
    }

    // 게시글 수정 (처리, POST)
    @PostMapping("/{id}/update")
    public String updatePost(@PathVariable("id") int id, AuthPostDto post, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        // 세션에서 userId 가져오기
        String userId = (String) request.getSession().getAttribute("userId");
        post.setUserId(userId);

        try {
            // 기존 게시글 정보 조회
            post.setId(id);
            AuthPostDto originalPost = authPostService.read(post.getId());

            // 업로드 파일 정보
            MultipartFile uploadFile = post.getUploadFile();

            // 업로드 파일이 있거나, 파일 삭제 체크되어 있는 경우
            if (uploadFile != null && !uploadFile.isEmpty() || post.isDeleteFile()) {
                // 기존 파일 삭제
                if (originalPost.getFileName() != null) {
                    Path filePath = Paths.get(uploadPath).resolve(originalPost.getFileName());
                    if (Files.exists(filePath)) {
                        Files.delete(filePath);
                    }
                }
            }            

            // 업로드 파일이 존재하는 경우
            if (uploadFile != null && !uploadFile.isEmpty()) {
                // 업로드 파일 이름
                String originalFileName = uploadFile.getOriginalFilename();

                // DB에 저장할 파일 이름
                String fileName = UUID.randomUUID().toString() + "_" + originalFileName;

                // 업로드 디렉토리가 없으면 생성
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // 파일 저장
                File destFile = new File(uploadPath + File.separator + fileName);
                uploadFile.transferTo(destFile);

                // 파일 정보 설정
                post.setFileName(fileName);
                post.setOriginalFileName(originalFileName);
            }

            // 게시글 수정
            boolean updated = authPostService.update(post);

            // 게시글 수정 성공
            if (updated) {
                redirectAttributes.addFlashAttribute("successMessage", "게시글이 수정되었습니다.");
                return "redirect:/posts/" + id;
            }

            // 게시글 수정 실패
            redirectAttributes.addFlashAttribute("errorMessage", "게시글 수정에 실패했습니다.");
            return "redirect:/posts/" + id + "/update";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "파일 업로드에 실패했습니다.");
            return "redirect:/posts/" + id + "/update";
        }             
    }    

    // 게시글 삭제 (처리, POST)
    @PostMapping("/{id}/delete")
    public String deletePost(@PathVariable int id, AuthPostDto post, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        // 세션에서 userId 가져오기
        String userId = (String) request.getSession().getAttribute("userId");
        post.setUserId(userId);

        post.setId(id);
        boolean deleted = authPostService.delete(post);

        // 게시글 삭제 성공
        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "게시글이 삭제되었습니다.");
            return "redirect:/posts/";
        }

        // 게시글 삭제 실패
        redirectAttributes.addFlashAttribute("errorMessage", "게시글 삭제에 실패했습니다.");
        return "redirect:/posts/" + id;
    }

    // 첨부파일 다운로드 (GET)
    @GetMapping("/{id}/download")
    public ResponseEntity<Resource> download(@PathVariable("id") int id) {       
        try {
            // 게시글 정보
            AuthPostDto post = authPostService.read(id);

            // 첨부파일 경로
            Path filePath = Paths.get(uploadPath).resolve(post.getFileName());
            Resource resource = new UrlResource(filePath.toUri());

            // 파일이 존재하고 읽을 수 있는지 확인
            if (!resource.exists() || !resource.isReadable()) {
                return ResponseEntity.notFound().build();
            }

            // 다운로드될 파일명 설정 (원본 파일명 사용)
            String fileName = post.getOriginalFileName();

            // 한글 파일명 처리
            String encodedFileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
            
            // 파일 다운로드
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"")
                    .body(resource);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
