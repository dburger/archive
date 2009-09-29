package com.bigtribe.root.servlet;

import java.awt.Color;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** Captcha servlet. */
public class CaptchaServlet extends HttpServlet {

    /**
     * Returns a captcha jpg and sets the captcha text as a
     * session attribute under CaptchaServlet.class.getName().
     *
     * @param req passed in request
     * @param res passed in response
     */
    public void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        Captcha captcha = new Captcha("Pasta my friend is good!", 28,
                Color.WHITE, Color.BLACK);
        req.setAttribute(CaptchaServlet.class.getName(), captcha.getText());
        res.setContentType("image/jpg");
        ImageIO.write(captcha.getImage(), "jpg", res.getOutputStream());
    }

}

/** Class to create a captcha image of given text. */
class Captcha {

    /** Text of the captcha. */
    private String _text;

    /** Font size. */
    private int _size;

    /** Captcha image. */
    private BufferedImage _buf;

    /** Background color for the captcha. */
    private Color _background;

    /** Foreground color for the captcha. */
    private Color _foreground;

    /** Maximum width for the captcha image. */
    private static final int MAX_WIDTH = 500;

    /** Maximum height for the captcha image. */
    private static final int MAX_HEIGHT = 500;

    /**
     * Basic constructor.
     *
     * @param text text to represent in the captcha
     * @param size font size to use in the captcha
     * @param background background color for captcha
     * @param foreground foreground color for captcha
     */
    public Captcha(String text, int size, Color background, Color foreground) {
        _text = text;
        _size = size;
        _background = background;
        _foreground = foreground;
    }

    /**
     * Returns the text represented in this captcha.
     *
     * @return text represented in this captcha
     */
    public String getText() {
        return _text;
    }

    /**
     * Returns the captcha image.
     *
     * @return captcha image
     */
    public BufferedImage getImage() {
        if (_buf == null) _buf = distortImage(createImage());
        return _buf;
    }

    /**
     * Creates the captcha image without distortion.
     *
     * @return captcha image, not distorted
     */
    private BufferedImage createImage() {
        BufferedImage buf = new BufferedImage(MAX_WIDTH, MAX_HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = (Graphics2D)buf.getGraphics();
        g.setColor(_background);
        g.fillRect(0, 0, MAX_WIDTH, MAX_HEIGHT);
        g.setColor(_foreground);
        Font font = new Font("arial", Font.PLAIN, _size);
        g.setFont(font);
        FontMetrics fm = g.getFontMetrics();
        int width = fm.stringWidth(_text);
        int height = fm.getHeight();
        g.drawString(_text, 0, height - fm.getDescent());
        g.dispose();
        return buf.getSubimage(0, 0, width, height);
    }

    /**
     * Distorts and returns the given image.
     *
     * @param buf image to distort
     * @return distorted image
     */
    private BufferedImage distortImage(BufferedImage buf) {
        // all the work would go here I suppose...not trivial
        return buf;
    }

}
