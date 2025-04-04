package com.example.spring.auth;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.spring.libs.Email;
import com.example.spring.libs.Sms;
import com.example.spring.user.UserDto;
import com.example.spring.user.UserService;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    UserService UserService;

    @Autowired
    PasswordEncoder passwordEncoder;

    // 로그인 (GET, 화면)
    @GetMapping("/login")
    public String loginGet(HttpServletRequest request) {
        // 로그인 되어 있으면 posts 페이지로 리다이렉트
        if (request.getSession().getAttribute("userId") != null) {
            return ("redirect:/posts");
        }

        // views/auth/login.jsp 파일 전달
        return ("auth/login");  
    }

    // 로그인 (POST, 처리)
    @PostMapping("/login")
    public String loginPost(
        HttpServletRequest request,
        RedirectAttributes redirectAttributes,
        @RequestParam(value = "userId") String userId,
        @RequestParam(value = "password") String password
    ) {
        // 로그인 되어 있으면 posts 페이지로 리다이렉트
        if (request.getSession().getAttribute("userId") != null) {
            return ("redirect:/posts");
        }

        // 로그인 사용자 정보(아이디, 비밀번호)
        UserDto loginUser = new UserDto();
        loginUser.setUserId(userId);

        // 사용자 정보
        UserDto user = UserService.read(loginUser);

        // 사용자 아이디와 비밀번호 검증
        if (user == null || !passwordEncoder.matches(password, user.getPassword())) {
            redirectAttributes.addFlashAttribute("userId", userId);
            redirectAttributes.addFlashAttribute("errorMessage", "아이디와 비밀번호를 확인하세요.");
            return ("redirect:/auth/login");
        }

        // 세션에 사용자 정보 저장
        request.getSession().setAttribute("userId", user.getUserId());
        request.getSession().setAttribute("userName", user.getUsername());

        // http://localhost:8080/posts 로 리다이렉트
        return ("redirect:/posts"); 
    }
    
    // 로그아웃
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        request.getSession(false).invalidate();
        return ("redirect:/auth/login");
    }

    // 회원가입 (GET, 화면)
    @GetMapping("/register")
    public String registerGet(HttpServletRequest request) {
        // 로그인 되어 있으면 posts 페이지로 리다이렉트
        if (request.getSession().getAttribute("userId") != null) {
            return ("redirect:/posts");
        }

        return ("auth/register");
    }

    // 회원가입 (POST, 처리)
    @PostMapping("/register")
    public String registerPost(
        UserDto user, 
        HttpServletRequest request, 
        RedirectAttributes redirectAttributes
    ) {
        // 로그인 되어 있으면 posts 페이지로 리다이렉트
        if (request.getSession().getAttribute("userId") != null) {
            return ("redirect:/posts");
        }

        // 사용자 정보 저장
        boolean result = UserService.create(user);

        // 회원가입 성공
        if (result) {
            redirectAttributes.addFlashAttribute("successMessage", "회원가입이 완료되었습니다.");
            return ("redirect:/auth/login");
        }

        // 회원가입 실패
        redirectAttributes.addFlashAttribute("errorMessage", "회원가입에 실패했습니다.");        
        return ("redirect:/auth/login");
    }

    // 아이디 찾기 (GET, 화면)
    @GetMapping("/find-user-id")
    public String findUserIdGet(HttpServletRequest request) {
        // 로그인 되어 있으면 posts 페이지로 리다이렉트
        if (request.getSession().getAttribute("userId") != null) {
            return ("redirect:/posts");
        }        

        return ("auth/findUserId");
    }

    // 아이디 찾기 (POST, 처리)
    @PostMapping("/find-user-id")
    public String findUserIdPost(
        HttpServletRequest request,
        RedirectAttributes redirectAttributes,
        @RequestParam(value = "username") String username,
        @RequestParam(value = "phone", required = false) String phone,
        @RequestParam(value = "email", required = false) String email
    ) {
        // 로그인 되어 있으면 posts 페이지로 리다이렉트
        if (request.getSession().getAttribute("userId") != null) {
            return ("redirect:/posts");
        }

        // 찾을 사용자 정보
        UserDto findUser = new UserDto();

        // 이름, 전화번호로 찾기
        if (username != null && phone != null && email == null) {
            findUser.setUsername(username);
            findUser.setPhone(phone);
        }

        // 이름, 이메일로 찾기
        else if (username != null && phone == null && email != null) {
            findUser.setUsername(username);
            findUser.setEmail(email);
        }

        // 사용자 정보 조회
        UserDto user = UserService.read(findUser);

        // 사용자 정보가 있으면 사용자 아이디 전달
        if (user != null) {
            if (phone != null) {
                Sms coolSMS = new Sms();
                coolSMS.sendSmsViaCoolsms("사용자 아이디는 " + user.getUserId() + " 입니다.", phone);
            } else if (email != null) {
                Email emailService = new Email();
                emailService.sendEmailViaNaver("아이디 찾기", "사용자 아이디는 " + user.getUserId() + " 입니다.", email);
            }            
            redirectAttributes.addFlashAttribute("successMessage", "사용자 아이디는 " + user.getUserId() + " 입니다.");
            return ("redirect:/auth/find-user-id");
        }

        redirectAttributes.addFlashAttribute("errorMessage", "사용자를 찾을 수 없습니다.");
        return ("redirect:/auth/find-user-id");
    }

    // 비밀번호 초기화 (GET, 화면)
    @GetMapping("/reset-password")
    public String resetPasswordGet(HttpServletRequest request) {
        // 로그인 되어 있으면 posts 페이지로 리다이렉트
        if (request.getSession().getAttribute("userId") != null) {
            return ("redirect:/posts");
        }

        return ("auth/resetPassword");
    }

    // 비밀번호 초기화 (POST, 처리)
    @PostMapping("/reset-password")
    public String resetPasswordPost(
        @RequestParam(value = "userId") String userId,
        @RequestParam(value = "phone", required = false) String phone,
        @RequestParam(value = "email", required = false) String email,
        RedirectAttributes redirectAttributes
    ) {
        // 찾을 사용자 정보
        UserDto findUser = new UserDto();

        // 아이디, 전화번호로 찾기
        if (userId != null && phone != null && email == null) {
            findUser.setUserId(userId);
            findUser.setPhone(phone);
        }

        // 아이디, 이메일로 찾기
        else if (userId != null && phone == null && email != null) {
            findUser.setUserId(userId);
            findUser.setEmail(email);
        }

        // 사용자 정보 조회
        UserDto user = UserService.read(findUser);

        // 사용자 정보가 있으면 비밀번호 초기화
        if (user != null) {
            // 랜덤 비밀번호 생성(6자리 숫자)
            double dValue = Math.random();
            int iValue = (int)(dValue * 1000000);
            String newPassword = String.valueOf(iValue);

            // 사용자 비밀번호 초기화
            user.setUserId(userId);
            user.setPassword(newPassword);
            boolean result = UserService.update(user);

            // 비밀번호 초기화 성공
            if (result) {
                if (phone != null) {
                    Sms coolSMS = new Sms();
                    coolSMS.sendSmsViaCoolsms("임시비밀번호는 " + newPassword + " 입니다.", phone);
                } else if (email != null) {
                    Email emailService = new Email();
                    emailService.sendEmailViaNaver("비밀번호 초기화", "임시비밀번호는 " + newPassword + " 입니다.", email);
                }
                redirectAttributes.addFlashAttribute("successMessage", "임시비밀번호는 " + newPassword + " 입니다.");
                return ("redirect:/auth/login");
            }
        }

        redirectAttributes.addFlashAttribute("errorMessage", "비밀번호를 초기화할 수 없습니다. 입력 정보를 확인하세요.");
        return ("auth/reset-password");
    }

    // 사용자 프로필 (GET, 화면)
    @GetMapping("/profile")
    public String profileGet() {
        return ("auth/profile");
    }

    // 사용자 프로필 수정 (GET, 화면)
    @GetMapping("/profile/update")
    public String updateGet(HttpServletRequest request, Model model) {
        // 세션에서 userId 가져오기
        String userId = (String) request.getSession().getAttribute("userId");

        // 사용자 정보 조회
        UserDto user = new UserDto();
        user.setUserId(userId);
        user = UserService.read(user);
        model.addAttribute("user", user);

        return ("auth/profile-update");
    }

    // 사용자 프로필 수정 (POST, 처리)
    @PostMapping("/profile/update")
    public String updatePost(UserDto user, RedirectAttributes redirectAttributes) {
        boolean result = UserService.update(user);

        if (result) {
            redirectAttributes.addFlashAttribute("successMessage", "사용자 정보가 수정되었습니다.");
            return ("redirect:/auth/profile");
        }

        redirectAttributes.addFlashAttribute("errorMessage", "사용자 정보 수정에 실패했습니다.");
        return ("redirect:/auth/profile");
    }

    // 사용자 비밀번호 수정 (GET, 화면)
    @GetMapping("/profile/update-password")
    public String updatePasswordGet() {
        return ("auth/profile-update-password");
    }

    // 사용자 비밀번호 수정 (POST, 처리)
    @PostMapping("/profile/update-password")
    public String updatePasswordPost(
        @RequestParam(value = "password") String password,
        HttpServletRequest request, 
        RedirectAttributes redirectAttributes
    ) {
        // 세션에서 userId 가져오기
        String userId = (String) request.getSession().getAttribute("userId");

        // 비밀번호 수정
        UserDto user = new UserDto();
        user.setUserId(userId);
        user.setPassword(password);
        boolean result = UserService.update(user);

        if (result) {
            redirectAttributes.addFlashAttribute("successMessage", "비밀번호가 수정되었습니다.");
            return ("redirect:/auth/profile");
        }

        redirectAttributes.addFlashAttribute("errorMessage", "비밀번호 수정에 실패했습니다.");
        return ("redirect:/profile/update-password");
    }

    // 사용자 탈퇴 (GET, 화면)
    @GetMapping("/profile/delete")
    public String deleteGet() {
        return ("auth/profile-delete");
    }

    // 사용자 탈퇴 (POST, 처리)
    @PostMapping("/profile/delete")
    public String deletePost(
        @RequestParam(value = "password") String password,
        HttpServletRequest request, 
        RedirectAttributes redirectAttributes
    ) {
        // 세션에서 userId 가져오기
        String userId = (String) request.getSession().getAttribute("userId");

        // 사용자 삭제
        UserDto user = new UserDto();
        user.setUserId(userId);
        boolean result = UserService.delete(user);

        if (result) {
            request.getSession(false).invalidate();
            redirectAttributes.addFlashAttribute("successMessage", "사용자 탈퇴가 완료되었습니다.");
            return ("redirect:/auth/logout");
        }

        redirectAttributes.addFlashAttribute("errorMessage", "사용자 탈퇴에 실패했습니다.");
        return ("redirect:/auth/profile/delete");
    }

    // 사용자 아이디 중복 체크 (POST, 처리)
    @PostMapping("/check-user-id")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkUserIdPost(@RequestParam(value = "userId") String userId) {
        // 사용자 정보 조회
        UserDto user = new UserDto();
        user.setUserId(userId);
        user = UserService.read(user);

        Map<String, Object> response = new HashMap<>();

        // 사용자 아이디가 존재하는 경우
        if (user != null) {
            response.put("exists", true);
        } 
        // 사용자가 존재하지 않는 경우
        else {
            response.put("exists", false);
        }

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
    }

    // 사용자 이메일 중복 체크 (POST, 처리)
    @PostMapping("/check-email")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkEmailPost(@RequestParam(value = "email") String email) {
        // 사용자 정보 조회
        UserDto user = new UserDto();
        user.setEmail(email);
        user = UserService.read(user);

        Map<String, Object> response = new HashMap<>();

        // 사용자가 존재하는 경우
        if (user != null) {
            response.put("exists", true);
        } 
        // 사용자 아이디가 존재하지 않는 경우
        else {
            response.put("exists", false);
        }

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
    }

    // 사용자 전화번호 중복 체크 (POST, 처리)
    @PostMapping("/check-phone")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkPhonePost(@RequestParam(value = "phone") String phone) {
        // 사용자 정보 조회
        UserDto user = new UserDto();
        user.setPhone(phone);
        user = UserService.read(user);

        Map<String, Object> response = new HashMap<>();

        // 사용자가 존재하는 경우
        if (user != null) {
            response.put("exists", true);
        } 
        // 사용자 아이디가 존재하지 않는 경우
        else {
            response.put("exists", false);
        }

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
    }
}
